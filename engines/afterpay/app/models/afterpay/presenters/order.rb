module Afterpay
  module Presenters
    class Order
      extend Forwardable

      attr_reader :spree_order
      def_delegators :spree_order,
                     :total,
                     :currency,
                     :email

      def_delegators :bill_address,
                     :phone,
                     :firstname,
                     :lastname

      def initialize(spree_order:)
        @spree_order = spree_order
      end

      private

      def bill_address
        spree_order.bill_address
      end
    end
  end
end
