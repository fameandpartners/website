module Bronto
  class SubscribeUsersWorker
    include Sidekiq::Worker

    def perform(list_name, emails)
      bronto_client.add_contacts(emails.map{ |email| { email: email }})
      bronto_client.add_to_list(list_name: list_name, emails: emails)
    end

    def bronto_client
      @bronto_client ||= Bronto::Client.new(api_token: ENV.fetch('BRONTO_API_TOKEN'),
                                            wsdl_path: ENV.fetch('BRONTO_WSDL'))
    end
  end
end
