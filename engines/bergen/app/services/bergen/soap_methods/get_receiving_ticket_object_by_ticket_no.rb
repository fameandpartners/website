module Bergen
  module SoapMethods
    class GetReceivingTicketObjectByTicketNo < BaseRequest
      attr_reader :client, :return_request_item

      def initialize(savon_client:, return_request_item:)
        @client              = savon_client
        @return_request_item = return_request_item
      end

      def response
        client.request :get_receiving_ticket_object_by_ticket_no do
          soap.body = required_fields_hash
        end
      end

      def result
        response_body = response[:get_receiving_ticket_object_by_ticket_no_response][:get_receiving_ticket_object_by_ticket_no_result][:receiving_ticket_by_ticket_no]
        response_body && response_body[:receiving_ticket]
      end

      private

      def required_fields_hash
        {
          'AuthenticationString' => client.auth_token,
          'AsnTicketNumber'      => asn_number,
        }
      end

      def asn_number
        return_request_item.item_return.bergen_asn_number
      end
    end
  end
end
