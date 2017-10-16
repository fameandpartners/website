class OrderBotWorker
  include Spree::OrderBotHelper
  include Sidekiq::Worker

  def perform(order_id)
   	order = Spree::Order.find(order_id)
    create_new_order_by_factory(order)
    order.orderbot_synced = true
    order.save!
  end
end
