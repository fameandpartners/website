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
        if item_return['Items']['Item'].kind_of?(Array)
          item_return['Items']['Item'].each do |item|
            puts "HELLOOO I AM HEEEEEERRREEE"

            unless order.autorefundable
              puts "HELLOOO I AM HEEEEEERRREEE"
              puts "refund #{item_return['Items']}"
              autorefund_items(order, item)
            end

            order.reload

            failed_items = order.line_items.select do |li|
              (CustomItemSku.new(li).call == item['SKU']) && (li.item_return.refund_status != 'Complete') # get items that were returned and invalid
            end

            failed_item_skus = failed_items.map { |li| CustomItemSku.new(li).call }

            puts item
            if item['ReturnReason'].downcase.include?('quarantine')
              puts "quarantine"
              puts item
              #QuarantinedReturnsMailer.email(order, item_return['Items']['Item'])

            elsif item['ReturnReason']
              puts "damaged"
              puts item
            end
          end

        else

          unless order.autorefundable
            puts "refund #{item_return['Items']}"
            puts item_return['Items']['Item']
            autorefund_items(order, item_return['Items']['Item'])
          end

          order.reload

          puts "things"
          puts item_return['Items']
          failed_items = order.line_items.select do |li|
            puts li.id
            (CustomItemSku.new(li).call == item_return['Items']['Item']['SKU']) && (li.item_return.refund_status != 'Complete') # get items that were returned and invalid
          end

          failed_item_skus = failed_items.map { |li| CustomItemSku.new(li).call }


          if item_return['Items']['Item']['ReturnReason'] && item_return['Items']['Item']['ReturnReason'].downcase.include?('quarantine')
            puts "quarantine"
            puts item_return['Items']['Item']
            #QuarantinedReturnsMailer.email(order, item_return['Items']['Item'])

          elsif item_return['Items']['Item']['ReturnReason'] && item_return['Items']['Item']['ReturnReason']
            puts "damaged"
            puts item_return['Items']['Item']
          end
        end
      end
    end
    scheduler.last_successful_run = current_time.to_s
    scheduler.save
  end
end

def autorefund_items(order, item)
  if item
    puts order.number
    puts item

    line_items = order.line_items.select { |li| CustomItemSku.new(li).call == 'USP1040US6AU10C61XHSD' }.take(item['QtyReturnedToStock'].to_i)# will return variant sku or personalization as needed to compare with sku
    # in case of multiple line items with matching skus only select the acceptable ones
    line_items.each do |li| # iterate over line_items and and move them along event progression.

      #receive_return(order, li)
      puts "goodbyeeeeee"
      puts li.id
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
