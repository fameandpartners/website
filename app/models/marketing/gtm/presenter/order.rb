module Marketing
  module Gtm
    module Presenter
      class Order < Base
        include ActionView::Helpers::NumberHelper

        extend Forwardable

        attr_reader :order, :base_url
        def_delegators :order, :currency, :number, :email

        # @param [Spree::Order] spree_order
        # @param [String] base_url. An absolute URL to the application's root.
        def initialize(spree_order:, base_url: nil)
          @order    = spree_order
          @base_url = base_url
        end

        def order_id
          order.id
        end

        def coupon_code
          order.promocode
        end

        def line_items
          order.line_items.map { |item| LineItem.new(spree_line_item: item, base_url: base_url).body }
        end

        def line_items_summary
          products_with_prices = order.line_items.map { |li| [li.variant.product.sku, li.total] }.uniq

          products_with_prices.map do |sku, price|
            qty = order.line_items.select { |li| li.variant.product.sku == sku && li.total == price }.size
            {
              id: sku,
              price: number_with_precision_wrapper(price),
              qty: qty
            }
          end
        end

        def total_amount
          order.total.to_f
        end

        def humanized_total_amount
          number_with_precision_wrapper(total_amount)
        end

        def taxes_amount
          order.adjustments.tax.sum(:amount).to_f
        end

        def shipping_amount
          order.adjustments.shipping.sum(:amount).to_f
        end

        def transaction_amount
          number_with_precision_wrapper(transaction.try(:amount).to_f)
        end

        def key
          'order'.freeze
        end

        def body
          {
              id:                     order_id,
              coupon_code:            coupon_code,
              number:                 number,
              email:                  email,
              currency:               currency,
              total_amount:           total_amount,
              taxes_amount:           taxes_amount,
              shipping_amount:        shipping_amount,
              line_items:             line_items,
              line_items_summary:     line_items_summary,
              humanized_total_amount: humanized_total_amount
          }
        end

        private

        def transaction
          @transaction ||= order.payments.where(state: 'completed').first
        end

        def number_with_precision_wrapper(number)
          number_with_precision(number, precision: 2, delimiter: ',')
        end
      end
    end
  end
end
