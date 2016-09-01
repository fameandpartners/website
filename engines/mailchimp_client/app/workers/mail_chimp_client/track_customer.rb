module MailChimpClient
  class TrackCustomer
    include Sidekiq::Worker

    def perform(user_id)
      user = Spree::User.find(user_id)
      MailChimpClient::API.new.add_customer(user)
    end
  end
end
