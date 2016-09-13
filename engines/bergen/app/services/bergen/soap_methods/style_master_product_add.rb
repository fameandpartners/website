module Bergen
  module SoapMethods
    class StyleMasterProductAdd < BaseRequest
      attr_reader :client, :return_request_items

      def initialize(savon_client:, return_request_items:)
        raise TypeError.new(:return_request_items) unless return_request_items.is_a?(Array)

        @client               = savon_client
        @return_request_items = return_request_items
      end

      def response
        client.request :style_master_product_add do
          soap.body = required_fields_hash
        end
      end

      def result
        response[:style_master_product_add_response][:style_master_product_add_result][:notifications][:notification]
      end

      private

      def required_fields_hash
        {
          'AuthenticationString' => client.auth_token,
          'products'             => {
            'StyleMasterProduct' => style_masters
          }
        }
      end

      def style_masters
        line_items_presenters.map { |line_item_presenter|
          global_sku = GlobalSku.find_or_create_by_line_item(line_item_presenter: line_item_presenter)

          {
            'Style' => global_sku.upc, # UPCs are being sent in place of Style: https://fameandpartners.atlassian.net/browse/WEBSITE-839
            'Color' => global_sku.color_name,
            'Size'  => global_sku.size,
            'UPC'   => global_sku.upc,
            'Price' => line_item_presenter.price
          }
        }
      end

      def line_items_presenters
        return_request_items.collect { |return_item| Orders::LineItemPresenter.new(return_item.line_item, nil) }
      end
    end
  end
end
