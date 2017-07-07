module Bronto
  module SubscribeUsersService
    class << self
      def perform(list_name, users)
        bronto_client = Bronto::Client.new
        user_id = bronto_client.add_contacts(users)
        bronto_client = Bronto::Client.new
        bronto_client.add_to_list(list_name: list_name, user_id: user_id)
      end
    end
  end
end
