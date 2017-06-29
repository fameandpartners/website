module Bronto
  module SubscribeUsersService
    class << self
      def perform(list_name, users)
        bronto_client.add_contacts(users)
        bronto_client.add_to_list(list_name: list_name, emails: users.map{ |user| user[:email] })
      end

      def bronto_client
        @bronto_client ||= Bronto::Client.new
      end
    end
  end
end
