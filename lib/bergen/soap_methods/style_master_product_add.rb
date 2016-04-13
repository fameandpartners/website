module Bergen
  module SoapMethods
    class StyleMasterProductAdd
      attr_reader :client, :return_request_item

      def initialize(savon_client:, return_request_item:)
        @client              = savon_client
        @return_request_item = return_request_item
      end

      def request
        client.request :style_master_product_add do
          soap.body = required_fields_hash
        end
      end

      private

      def required_fields_hash
        {
          'AuthenticationString' => client.auth_token,
          'products'             => {
            'StyleMasterProduct' => {
              'Style' => global_sku.style_number,
              'Color' => global_sku.color_name,
              'Size'  => global_sku.size,
              'UPC'   => global_sku.sku,
              'Price' => line_item_presenter.price
            }
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
