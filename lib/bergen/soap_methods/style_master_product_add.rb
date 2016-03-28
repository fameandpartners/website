module Bergen
  module SoapMethods
    class StyleMasterProductAdd
      attr_reader :client, :auth_token, :return_request_item

      def initialize(savon_client:, auth_token:, return_request_item:)
        @client              = savon_client
        @auth_token          = auth_token
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
          'AuthenticationString' => auth_token,
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
        Orders::LineItemPresenter.new(return_request_item.line_item, return_request_item.order)
      end

      def global_sku
        GlobalSku.find_or_create_by_line_item(line_item_presenter: line_item_presenter)
      end
    end
  end
end
