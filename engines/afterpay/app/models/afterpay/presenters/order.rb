module Afterpay
  module Presenters
    class Order
      extend Forwardable

      attr_reader :spree_order
      def_delegators :spree_order,
                     :total,
                     :currency,
                     :email,
                     :number

      def_delegators :bill_address,
                     :phone,
                     :firstname,
                     :lastname,
                     :address1,
                     :address2,
                     :city,
                     :state_name,
                     :zipcode,
                     :country

      def_delegators :country, :iso3

      def initialize(spree_order:)
        @spree_order = spree_order
      end

      def name
        "#{first_name} #{last_name}"
      end

      private

      def bill_address
        spree_order.bill_address
      end
    end
  end
end
