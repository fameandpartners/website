module Bergen
  module SoapMethods
    class GetStyleMasterProductAddStatus < BaseRequest
      attr_reader :client, :spree_variant

      def initialize(savon_client:, spree_variant:)
        @client        = savon_client
        @spree_variant = spree_variant
      end

      def request
        client.request :get_style_master_product_add_status do
          soap.body = required_fields_hash
        end
      end

      private

      def required_fields_hash
        {
          'AuthenticationString' => client.auth_token,
          'UPC'                  => global_sku.upc,
        }
      end

      def global_sku
        GlobalSku.find_or_create_by_spree_variant(variant: spree_variant)
      end
    end
  end
end
