module MailChimp
  class TrackOrder
    include Sidekiq::Worker

    def perform(order_id)
      order = Spree::Order.find(order_id)
      MailChimp::Order::Create.(order)
    end
  end
end
