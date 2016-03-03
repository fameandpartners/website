module Marketing
  module Gtm
    module Presenter
      class Order < Base
        extend Forwardable

        attr_reader :order
        def_delegators :order, :currency, :number, :email

        def initialize(spree_order:)
          @order = spree_order
        end

        def line_items
          order.line_items.map { |item| LineItem.new(spree_line_item: item).body }
        end

        def total_amount
          order.total.to_f
        end

        def taxes_amount
          order.adjustments.tax.sum(:amount).to_f
        end

        def shipping_amount
          order.adjustments.shipping.sum(:amount).to_f
        end

        def key
          'order'.freeze
        end

        def body
          {
              number:          number,
              email:           email,
              currency:        currency,
              total_amount:    total_amount,
              taxes_amount:    taxes_amount,
              shipping_amount: shipping_amount,
              line_items:      line_items
          }
        end
      end
    end
  end
end
