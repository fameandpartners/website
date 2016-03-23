module Bergen
  class GetStyleMasterProductAddStatus
    attr_reader :client, :auth_token, :return_request_item

    def initialize(savon_client:, auth_token:, return_request_item:)
      @client              = savon_client
      @auth_token          = auth_token
      @return_request_item = return_request_item
    end

    def request
      client.request :get_style_master_product_add_status do
        soap.body = required_fields_hash
      end
    end

    private

    def required_fields_hash
      {
        'AuthenticationString' => auth_token,
        'UPC'                  => global_sku.sku,
      }
    end

    # TODO, probably too overkill for this simple XML
    def line_item_presenter
      Orders::LineItemPresenter.new(return_request_item.line_item, return_request_item.order)
    end

    def global_sku
      GlobalSku.find_or_create_by_line_item(line_item_presenter: line_item_presenter)
    end
  end
end
