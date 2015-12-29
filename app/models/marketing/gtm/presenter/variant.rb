module Marketing
  module Gtm
    module Presenter
      class Variant < Base
        attr_reader :variant

        def initialize(spree_variant:)
          @variant = spree_variant
        end

        def key
          'variant'.freeze
        end

        def sku
          VariantSku.new(variant).call
        end

        def body
          {
              sku: sku
          }
        end
      end
    end
  end
end
