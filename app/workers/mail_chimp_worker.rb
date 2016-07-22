class MailChimpWorker
  include Sidekiq::Worker

  def perform(order)
    MailChimpClient.new.add_order(order)
  end
end
