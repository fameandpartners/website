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
      res['response']['Returns']['Return'].each do |item_return|
        order = Spree::Order.find_by_number(item_return['orderID'])
        unless order.autorefundable
          autorefund_items(order, item_return['Items'])
        end
        
        order.reload
        failed_items = order.line_items.select do |li|
          (CustomItemSku.new(li).call == item_return['Items']['Item']['SKU']) && (li.item_return.refund_status != 'Complete') # get items that were returned and invalid
        end

        failed_item_skus = failed_items.map { |li| CustomItemSku.new(li).call }


        if item_return['Items']['Item']['ReturnReason'].downcase.include?('quarantine')
          QuarantinedReturnsMailer.email(order, item_return['Items']['Item'])

        elsif item_return['Items']['Item']['ReturnReason']
          DamagedReturnsMailer.email(order, item_return['Items']['Item'])
        end


        # unless failed_items.nil? || failed_items.empty?

        #   newgistics_order_id = item_return['orderID']
        #   inventory_response = client.get_inventory_details(scheduler.last_successful_run)

        #   inventory_response['response']['inventories']['inventory'].select do |inventory|
        #     inventory['order_id'] == newgistics_order_id
        #   end

        #   damaged_inventory_items = inventories.select do |item|
        #     item['reasonCode']['id'].to_i < 4 && failed_item_skus.include?(item['SKU']) # codes 1,2,3 represent damage in some form
        #   end
        #   quarantined_inventory_items = inventories.select do |item|
        #     item['reasonCode']['id'].to_i == 10 && failed_item_skus.include?(item['SKU']) # codes 10 represent quarantined
        #   end
        # end

        # unless damaged_inventory_items.nil? || damaged_inventory_items.empty?
        #   DamagedReturnsMailer.email(order, damaged_inventory_items)
        # end

        # unless quarantined_inventory_items.nil? || quarantined_inventory_items.empty?
        #   QuarantinedReturnsMailer.email(order, damaged_inventory_items)
        # end

      end
    end
    scheduler.last_successful_run = current_time.to_s
    scheduler.save
  end
end

def autorefund_items(order, items)
  item = items['Item']
  if item
      line_items = order.line_items.select { |li| CustomItemSku.new(li).call == item['SKU'] }# will return variant sku or personalization as needed to compare with sku
                        .take(item['QtyReturnedToStock'].to_i) # in case of multiple line items with matching skus only select the acceptable ones
      line_items.each do |li| # iterate over line_items and and move them along event progression.
        #receive_return(order, li)

        accept_return(order, li)

        refund_return(order, li)

        NewgisticsRefundMailer.email(order, li)
      end
  end
end

def accept_return(order, line_item)
  form_data = {
    user: order.email,
    comment: 'Returned to Newgistics'
  }

  event = line_item.item_return(item_return_id: line_item.item_return.id).events.send('approve').build
  form = ::Forms::ApproveForm.new(event)
  form.validate(form_data) && form.save
end

def receive_return(order, line_item)
  form_data = {
    user: order.email,
    comment: 'Recieved'
  }

  event = line_item.item_return(item_return_id: line_item.item_return.id)
                   .events
                   .send('receive_item').build
  form = ::Forms::ReceiveItemForm.new(event)
  form.validate(form_data) && form.save
end

def refund_return(order, line_item)
  form_data = {
    'user' => order.email,
    'refund_amount' => line_item.item_return.item_price_adjusted.to_f / 100,
    'comment' => 'Returned to Newgistics'
  }

  RefundService.new(item_return_id: line_item.item_return.id,
                    refund_data: form_data)
               .process
end
