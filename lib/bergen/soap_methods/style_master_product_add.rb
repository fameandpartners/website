module Bergen
  module SoapMethods
    class StyleMasterProductAdd
      attr_reader :client, :spree_variant

      def initialize(savon_client:, spree_variant:)
        @client        = savon_client
        @spree_variant = spree_variant
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
              'UPC'   => global_sku.upc,
              'Price' => spree_variant.price
            }
          }
        }
      end

      def global_sku
        GlobalSku.find_or_create_by_spree_variant(variant: spree_variant)
      end
    end
  end
end
