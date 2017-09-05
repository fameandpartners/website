namespace :data do
  desc 'Wipe out records associated with a order return request'
  task :wipey_return, [:order_number] => [:environment] do [t, args]

      ord = Spree::Order.find_by_order_number[args[:order_number]]

      orr = OrderReturnRequest.find_by_order_id(ord.id)

      ir_arr = ItemReturn.where(order_number: [args[:order_number]])
      ir_arr.map(&:destroy)

      rri_arr = ReturnRequestItem.where(order_return_request_id: orr.id)
      rri_arr.map(&:destroy)

      orr.destroy

  end
end
