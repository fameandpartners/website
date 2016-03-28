module Bergen
  module SoapMethods
    class ReceivingTicketAdd
      attr_reader :client, :return_request_item

      def initialize(savon_client:, return_request_item:)
        @client              = savon_client
        @return_request_item = return_request_item
      end

      def request
        client.request :receiving_ticket_add do
          soap.body = required_fields_hash
        end
      end

      private

      def required_fields_hash
        {
          'AuthenticationString'  => client.auth_token,
          'SupplierDetails'       => {
            'CompanyName' => 'Fame & Partners',
            'State'       => 'NY',
            'Country'     => 'Australia'
          },
          'ReceivingTicketObject' => {
            'Carrier'          => 'Shipping Company Name',
            'Warehouse'        => 'BERGEN LOGISTICS NJ',
            'ShipmentTypelist' => 'OPENTOHANG'
          },
          'Shipmentitemslist'     => {
            'SKU'              => global_sku.sku,
            'Style'            => global_sku.style_number,
            'Color'            => global_sku.color_name,
            'Size'             => global_sku.size,
            'ExpectedQuantity' => '0', # Required, but field is ignored
            'ActualQuantity'   => '0', # Required, but field is ignored
            'DamagedQuantity'  => '0' # Required, but field is ignored
          }
        }
      end

      def line_item_presenter
        return_request_item.line_item_presenter
      end

      def global_sku
        line_item_presenter.global_sku
      end
    end
  end
end
