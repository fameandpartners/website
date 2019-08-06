# frozen_string_literal: true
namespace :newgistics do
  task update_item_returns: :environment do

    order1 = Spree::Order.find_by_number('r834564042')
    if order1.nil?
      puts "lowcase order is nil: r834564042"
    else
      puts "lowcase order is not nil: r834564042"
    end
    order2 = Spree::Order.find_by_number('R834564042')
    if order2.nil?
      puts "upcase order is nil: R834564042"
    else
      puts "upcase order is not nil: R834564042"
    end

    if (scheduler = Newgistics::NewgisticsScheduler.find_by_name('item_return')).nil?
      scheduler = Newgistics::NewgisticsScheduler.new
      scheduler.last_successful_run = 1.day.ago.utc.to_datetime.to_s
      scheduler.name = 'item_return'
      scheduler.save
    end
    current_time = Date.today.beginning_of_day.utc.to_datetime.to_s
    client = Newgistics::NewgisticsClient.new

    start_time = Time.parse(scheduler.last_successful_run.to_s).utc
    end_time = (start_time + 5.day).utc
    now_time = Time.now.utc

    while end_time <= now_time do
      puts "---------------------------------------------------"
      puts "range: " + start_time.to_datetime.to_s + " --- " + end_time.to_datetime.to_s
      res = client.get_returns(start_time.to_datetime.to_s, end_time.to_datetime.to_s)
      puts res

      # TODO REMOVE ME
      if Rails.env.production?
        ActionMailer::Base.mail(from: "noreply@fameandpartners.com",
                                to: "davidp@fameandpartners.com",
                                cc: "catherinef@fameandpartners.com",
                                subject: "rake newgistics:update_item_returns",
                                body: res.inspect).deliver
      end

      response_returns = res['response']['Returns']['Return'] rescue []
      if res['response'].nil?
        NewRelic::Agent.notice_error(res.to_s)
        Raven.capture_exception(res.to_s)
      elsif  !res['response'].has_key?('Returns')
        NewRelic::Agent.notice_error(res['response'].to_s)
        Raven.capture_exception(res['response'].to_s)
      else
        response_returns.each do |item_return|
          order = Spree::Order.find_by_number(item_return['orderID'])
          if order.nil?
            puts "order is nil: " + item_return['orderID']
          end
          next
        end
      end
      start_time = end_time
      if end_time >= now_time
        break
      end
      end_time = (end_time + 5.day).utc
      if end_time > now_time
        end_time = now_time
      end
    end

    scheduler.last_successful_run = current_time.to_s
    if Rails.env.production?
      scheduler.save
    end
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
