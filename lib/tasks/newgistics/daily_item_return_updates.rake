namespace :newgistics do
  task :update_item_returns => :environment do
    client = Newgistics::NewgisticsClient.new

    res = client.get_inbound_returns(1.day.ago.to_time, Time.now.utc)

    res["response"]['Returns']&.each do |item_return|
      order = Spree::Order.find_by_number(item_return['RmaNumber'].to_i)
      item_return['Items']&.each do |item|
        line_items = order.line_items.select{ |li| li.sku == item['SKU']}.take(item['QtyReturnedToStock'].to_i)
        line_items.each do |li|

          form_data = {
            :user => order.email,
            "comment" => ""
          }

          event = li.item_return(item_return_id: li.item_return.id).events.send('receive_item').build
          form = ::Forms::ReceiveItemForm.new(event)
          form.validate(form_data) && form.save!

          form_data = {
            :user => order.email,
            "comment" => ""
          }

          event = li.item_return(item_return_id: li.item_return.id).events.send('approve').build
          form = ::Forms::ApproveForm.new(event)
          form.validate(form_data) && form.save!

          form_data = {
            :user => order.email,
            "refund_amount" => li.item_return.item_price_adjusted.to_f/100,
            "comment" => "Returned to Newgistics"
          }

          result = RefundService.new(item_return_id: li.item_return.id, refund_data: form_data).process

          #TODO: Send Email to customer that refund has been processed
        end

        failed_items = order.line_items.select {|li| li.sku == item['SKU'] && li.item_return.status != 'Comlete'}
        failed_items.each do |li|
          #TODO: Send email with the order number and line item id
        end
      end
    end
  end
end

