module Afterpay
  module Presenters
    class Payment
      def initialize(spree_order:, spree_payment_method:, rails_request:)
        @rails_request        = rails_request
        @spree_order          = spree_order
        @spree_payment_method = spree_payment_method
      end

      private def order
        ::Afterpay::Presenters::Order.new(spree_order: @spree_order)
      end

      private def payment_method
        ::Afterpay::Presenters::PaymentMethod.new(spree_payment_method: @spree_payment_method)
      end

      private def checkout_url
        Spree::Core::Engine.routes.url_helpers.checkout_url(
          host:     @rails_request.host,
          port:     @rails_request.port,
          protocol: @rails_request.protocol
        )
      end

      def get_token
        result = payment_method.create_order(
          {
            totalAmount:       {
              amount:   order.total,
              currency: order.currency
            },
            consumer:          {
              phoneNumber: order.phone,
              givenNames:  order.firstname,
              surname:     order.lastname,
              email:       order.email
            },
            merchant:          {
              redirectConfirmUrl: 'http://au.lvh.me:3000/afterpay/confirm',
              redirectCancelUrl:  checkout_url
            },
            merchantReference: payment_method.preferred_username
          }
        )

        result['token']
      rescue StandardError => e
        Raven.capture_exception(e)
        false
      end

      def order_eligible?
        max_allowed_amount = payment_method.configuration[0]['maximumAmount']['amount']
        order.total <= max_allowed_amount.to_f
      rescue StandardError => e
        Raven.capture_exception(e)
        false
      end

      def test_mode?
        payment_method.preferred_test_mode
      end

      def single_installment_text
        Spree::Money.new(order.total, currency: 'AUD').to_s
      end

      def order_total_text
        single_installment = order.total / 4
        Spree::Money.new(single_installment, currency: 'AUD').to_s
      end
    end
  end
end
