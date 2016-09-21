module MailChimp
  class CreateStore
    include Sidekiq::Worker

    def perform
      MailChimp::Store::Create.()
    end
  end
end
