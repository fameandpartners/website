class OrderBotWorker
  include Spree::OrderBotHelper
  include Sidekiq::Worker

  sidekiq_options :retry => 5

  def perform(order_id)
   	order = Spree::Order.find(order_id)
    create_new_order_by_factory(order)
    order.orderbot_success = true
    order.save!
  end
end
