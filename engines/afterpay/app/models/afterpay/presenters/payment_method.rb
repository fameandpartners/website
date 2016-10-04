module Afterpay
  module Presenters
    class PaymentMethod
      extend Forwardable

      attr_reader :spree_payment_method
      def_delegators :spree_payment_method,
                     :preferred_username,
                     :preferred_test_mode

      def_delegators :provider,
                     :create_order,
                     :configuration

      def initialize(spree_payment_method:)
        @spree_payment_method = spree_payment_method
      end

      private

      def provider
        spree_payment_method.provider
      end
    end
  end
end
