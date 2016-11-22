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
    end
  end
end
