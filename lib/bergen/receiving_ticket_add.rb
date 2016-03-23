module Bergen
  class ReceivingTicketAdd
    attr_reader :client, :auth_token, :return_request_item

    def initialize(savon_client:, auth_token:, return_request_item:)
      @client              = savon_client
      @auth_token          = auth_token
      @return_request_item = return_request_item
    end

    def request
      client.request :receiving_ticket_add do
        soap.body = required_fields_hash
      end
    end

    private def required_fields_hash
      {
        'AuthenticationString'  => auth_token,
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
          'SKU'              => 'Product SKU',
          'Style'            => 'Product Style',
          'Color'            => 'Product Color',
          'Size'             => 'Product Size',
          'ExpectedQuantity' => '0', # Required, but field is ignored
          'ActualQuantity'   => '0', # Required, but field is ignored
          'DamagedQuantity'  => '0' # Required, but field is ignored
        }
      }
    end

  end
end
