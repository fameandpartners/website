# frozen_string_literal: true
namespace :newgistics do
  task update_item_returns: :environment do

    if (scheduler = Newgistics::NewgisticsScheduler.find_by_name('item_return')).nil?
      scheduler = Newgistics::NewgisticsScheduler.new
      scheduler.last_successful_run = 1.day.ago.utc.to_datetime.to_s
      scheduler.name = 'item_return'
      scheduler.save
    end
    current_time = Date.today.beginning_of_day.utc.to_datetime.to_s
    client = Newgistics::NewgisticsClient.new
    res = client.get_returns(scheduler.last_successful_run, current_time)
    if res['response'].nil?
      NewRelic::Agent.notice_error(res.to_s)
      Raven.capture_exception(res.to_s)
    elsif  !res['response'].has_key?('Returns')
      NewRelic::Agent.notice_error(res['response'].to_s)
      Raven.capture_exception(res['response'].to_s)
    else
      res['response']['Returns'].each do |item_return|
        order = Spree::Order.find_by_number(item_return['RmaNumber'].to_i)
        item_return['Items']&.each do |item|
          line_items = order.line_items.select { |li| li.personalization.sku == item['SKU'] }
                            .take(item['QtyReturnedToStock'].to_i)
          line_items.each do |li|
            receive_return(order, li)

            accept_return(order, li)

            refund_return(order, line_item)
            # TODO: Send Email to customer that refund has been processed
          end

        end
        failed_items = order.line_items.select do |li|
          li.personalization.sku == item['SKU'] && li.item_return.status != 'Complete'
        end

        failed_item_skus = failed_items.map { |li| li.personalization.sku }

        unless failed_items.empty?

          newgistics_order_id = item_return['orderID']
          inventory_response = client.get_inventory_details(scheduler.last_successful_run)

          inventories = inventory_response['inventories'].select do |inventory|
            inventory['order_id'] == newgistics_order_id
          end

          damaged_inventory_items = inventories.select do |item|
            item['reasonCode']['id'].to_i < 4 && failed_item_skus.include?(item['SKU'])
          end
          quarantined_inventory_items = inventories.select do |item|
            item['reasonCode']['id'].to_i == 10 && failed_item_skus.include?(item['SKU'])
          end
        end

        unless damaged_inventory_items.empty?
          DamagedReturnsMailer.email(order, damaged_inventory_items)
        end

        unless quarantined_inventory_items.empty?
          QuarantinedReturnsMailer.email(order, damaged_inventory_items)
        end

      end
    end
    scheduler.last_successful_run = current_time.to_s
    scheduler.save
  end
end
def accept_return(order, line_item)
  form_data = {
    user: order.email,
    comment: 'Returned to Newgistics'
  }

  event = line_item.item_return(item_return_id: line_item.item_return.id)
                   .events
                   .send('approve').build
  form = ::Forms::ApproveForm.new(event)
  form.validate(form_data) && form.save!
end

def receive_return(order, line_item)
  form_data = {
    user: order.email,
    comment: ''
  }

  event = line_item.item_return(item_return_id: line_item.item_return.id)
                   .events
                   .send('receive_item').build
  form = ::Forms::ReceiveItemForm.new(event)
  form.validate(form_data) && form.save!
end

def refund_return(order, line_item)
  form_data = {
    user: order.email,
    refund_amount: line_item.item_return.item_price_adjusted.to_f / 100,
    comment: 'Returned to Newgistics'
  }

  RefundService.new(item_return_id: line_item.item_return.id,
                    refund_data: form_data)
               .process
end
