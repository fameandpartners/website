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
    last_successful_run = scheduler.last_successful_run
    client = Newgistics::NewgisticsClient.new
    res = client.get_returns(last_successful_run, current_time)

    # TODO REMOVE ME
    if Rails.env.production?
      ActionMailer::Base.mail(from: "noreply@fameandpartners.com",
                              to: "davidp@fameandpartners.com",
                              cc: "catherinef@fameandpartners.com;hzsoft@graphicchina.com",
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
      flag = false
      csv_headers = ['OrderId', 'Name', 'Address1', 'City', 'State','PostalCode',
                     'Timestamp']
      temp_file = Tempfile.new('foo')  # self GC temp_file
      #temp_file = File.new("export\\returnorder\\#{start_time.year}#{start_time.month}#{start_time.day}.csv", "w+")
      csv_file = CSV.open(temp_file, 'wb') do |csv|
        csv << csv_headers # set headers for csv
        response_returns.each do |item_return|
          order_id = item_return['orderID'].lstrip
          order_id = order_id.gsub(/[e]/, 'E')
          order_id = order_id.gsub(/[r]/, 'R')
          order_id = order_id.gsub(/[m]/, 'M')
          order_id.insert(0,'R') if order_id[0,1]=~ /[0-9]/
          order = Spree::Order.find_by_number(order_id)
          if order.nil?
            flag = true
            puts "order is nil: " + item_return['orderID']
            puts "order is nil after transform: " + order_id
            csv << [item_return['orderID'], item_return['Name'], item_return['Address1'],
                    item_return['City'], item_return['State'], item_return['PostalCode'],item_return['Timestamp']]
            next
          end

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
              if item['ReturnReason']&.downcase&.include?('quarantine')
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
      if flag
        if Rails.env.production?
          # TODO REMOVE ME
          ActionMailer::Base.mail(from: "noreply@fameandpartners.com",
                                  to: "davidp@fameandpartners.com",
                                  cc: "jonathanv@fameandpartners.com;hzsoft@graphicchina.com",
                                  subject: "Error list:upload_return_list",
                                  body: temp_file.read).deliver
        end
        temp_file.close
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
