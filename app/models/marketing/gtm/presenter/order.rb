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

        def discount_amount
          order.display_promotion_total&.money&.amount&.to_f
        end

        def transaction_amount
          number_with_precision_wrapper(transaction.try(:amount).to_f)
        end

        def phase
          if (order.state == 'cart')
            return 'SHOPPING';
          end
      
          if (order.state == 'address')
            return 'SHIPPING_INFO';
          end
      
          if (order.state == 'payment')
            return 'PAYMENT';
          end
      
          if (order.state == 'confirm')
            return 'ORDER_REVIEW';
          end
      
          if (order.state ==='complete')
            return 'ORDER_COMPLETE';
          end
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
              discount_amount:        discount_amount || 0,
              line_items:             line_items,
              humanized_total_amount: humanized_total_amount,
              phase:                  phase,
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
