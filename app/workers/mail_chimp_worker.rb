class MailChimpWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Spree::Order.find(order_id)
    MailChimpClient.new.add_order(order)
  end
end
