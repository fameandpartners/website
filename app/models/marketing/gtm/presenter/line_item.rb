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
              sku:          sku,
              name:         product_name,
              category:     category,
              total_amount: total_amount,
              quantity:     quantity
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
