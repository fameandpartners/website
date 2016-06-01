module Bergen
  module SoapMethods
    class StyleMasterProductAddBySpreeVariants < BaseRequest
      attr_reader :client, :spree_variants

      def initialize(savon_client:, spree_variants:)
        raise TypeError.new(:spree_variants) unless spree_variants.is_a?(Array)

        @client         = savon_client
        @spree_variants = spree_variants
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
        spree_variants.map { |variant|
          global_sku = GlobalSku.find_or_create_by_spree_variant(variant: variant)

          {
            'Style' => global_sku.style_number,
            'Color' => global_sku.color_name,
            'Size'  => global_sku.size,
            'UPC'   => global_sku.upc,
            'Price' => variant.price
          }
        }
      end
    end
  end
end
