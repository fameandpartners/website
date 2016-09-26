module Bergen
  module SoapMethods
    class GetStyleMasterProductAddStatus < BaseRequest
      attr_reader :client, :return_request_item
      #
      def initialize(savon_client:, return_request_item:)
        @client                 = savon_client
        @return_request_item = return_request_item
      end

      def response
        client.request :get_style_master_product_add_status do
          soap.body = required_fields_hash
        end
      end

      def result
        response[:get_style_master_product_add_status_response][:get_style_master_product_add_status_result][:notifications][:notification]
      end

      private

      def required_fields_hash
        {
          'AuthenticationString' => client.auth_token,
          'UPC'                  => global_sku.upc,
        }
      end

      def global_sku
        GlobalSku.find_or_create_by_line_item(line_item_presenter: line_item_presenter)
      end

      def line_item_presenter
        line_item = return_request_item.line_item
        Orders::LineItemPresenter.new(line_item, line_item.order)
      end
    end
  end
end
