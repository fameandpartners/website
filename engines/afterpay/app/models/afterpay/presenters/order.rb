module Afterpay
  module Presenters
    class Order
      extend Forwardable

      attr_reader :spree_order
      def_delegators :spree_order,
                     :total,
                     :currency,
                     :email,
                     :number,
                     :bill_address,
                     :ship_address

      def_delegators :bill_address,
                     :phone,
                     :firstname,
                     :lastname

      def initialize(spree_order:)
        @spree_order = spree_order
      end

      def billing_state
        bill_address.state&.abbr || bill_address.state_name
      end

      def shipping_state
        ship_address.state&.abbr || ship_address.state_name
      end
    end
  end
end
