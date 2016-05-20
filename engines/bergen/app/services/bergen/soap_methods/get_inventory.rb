module Bergen
  module SoapMethods
    class GetInventory < BaseRequest
      attr_reader :client

      def initialize(savon_client:)
        @client = savon_client
      end

      def response
        client.request :get_inventory do
          soap.body = required_fields_hash
        end
      end

      def result
        response[:get_inventory_response][:get_inventory_result][:inventory][:item]
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
