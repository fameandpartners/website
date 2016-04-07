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
          'AuthenticationString' => client.auth_token,
          'receivingTicket'      => {
            'ReceivingStatus'     => 'Draft',
            'ReceivingStatusCode' => 0,
            'CreatedDate'         => '07/04/2016',
            'Shipmentitemslist'   => {
              'Sku'              => global_sku.sku,
              'Color'            => global_sku.color_name,
              'UPC'              => global_sku.id,
              'Size'             => global_sku.size,
              'Style'            => global_sku.style_number,
              'ExpectedQuantity' => '0', # Required, but field is ignored
              'ActualQuantity'   => '0', # Required, but field is ignored
              'DamagedQuantity'  => '0' # Required, but field is ignored
            },
            'ShipmentTypelist'    => 'OPENTOHANG',
            'Warehouse'           => 'Bergen Logistics NJ2',
            'SupplierDetails'     => {
              'CompanyName' => 'Fame & Partners',
              'Country'     => 'Australia'
            },
            'Carrier'             => 'Truck',
          }
        }

        # {
        #   'AuthenticationString' => client.auth_token,
        #   'receivingTicket'      => {
        #     'Carrier'           => 'Truck', # Carrier should be the method being used to ship the product to us. If UPS is shipping the product, then this would be UPS. If you don't know what the carrier is, you can default to "Truck".
        #     'Warehouse'         => 'Bergen Logistics NJ2',
        #     'ShipmentTypelist'  => 'Open To Hang',
        #     'Shipmentitemslist' => {
        #       'SKU'              => global_sku.sku,
        #       'Style'            => global_sku.style_number,
        #       'Color'            => global_sku.color_name,
        #       'Size'             => global_sku.size,
        #       'ExpectedQuantity' => '0', # Required, but field is ignored
        #       'ActualQuantity'   => '0', # Required, but field is ignored
        #       'DamagedQuantity'  => '0' # Required, but field is ignored
        #     },
        #     'SupplierDetails'   => {
        #       'CompanyName' => 'Fame & Partners',
        #       'Country'     => 'Australia'
        #     }
        #   }
        # }
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
