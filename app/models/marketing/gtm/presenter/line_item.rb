module Marketing
  module Gtm
    module Presenter
      class LineItem < Base
        extend Forwardable

        attr_reader :line_item
        def_delegators :@line_item, :quantity

        def initialize(spree_line_item:)
          @line_item = spree_line_item
        end

        def key
          'line_item'.freeze
        end

        def sku
          CustomItemSku.new(line_item).call
        end

        def variant_sku
          VariantSku.new(variant).call
        end

        def product_sku
          product.sku
        end

        def product_name
          product.name
        end

        def category
          product.taxons.first.try(:name)
        end

        def total_amount
          line_item.total.to_f
        end

        def body
          {
              category:     category,
              name:         product_name,
              quantity:     quantity,
              total_amount: total_amount,
              sku:          sku,
              variant_sku:  variant_sku,
              product_sku:  product_sku
          }
        end

        private def variant
          line_item.variant
        end

        private def product
          variant.product
        end
      end
    end
  end
end
