module Bergen
  module SoapMethods
    class GetInventory
      attr_reader :client

      def initialize(savon_client:)
        @client = savon_client
      end

      def request
        client.request :get_inventory do
          soap.body = required_fields_hash
        end
      end

      private

      def required_fields_hash
        {
          'AuthenticationString' => client.auth_token
        }
      end
    end
  end
end
