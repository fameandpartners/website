module MailChimpClient
  class TrackOrder
    include Sidekiq::Worker

    def perform(order_id)
      order = Spree::Order.find(order_id)
      MailChimpClient::API.new.add_order(order)
    end
  end
end
