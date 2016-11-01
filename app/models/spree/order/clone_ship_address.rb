# This module allows Spree orders to clone bill address to ship address, instead of ship to bill
# Source: https://github.com/spree/spree/blob/1-3-stable/core/app/models/spree/order.rb#L75
module Spree
  class Order
    module CloneShipAddress
      extend ActiveSupport::Concern

      included do
        attr_accessor :use_shipping
        attr_accessible :use_shipping
        before_validation :clone_shipping_address, if: :use_shipping?
      end

      def clone_shipping_address
        if ship_address && self.bill_address.nil?
          self.bill_address = ship_address.clone
        else
          self.bill_address.attributes = ship_address.attributes.except('id', 'updated_at', 'created_at')
        end
        true
      end

      def use_shipping?
        use_shipping.in?([true, 'true', '1'])
      end
    end
  end
end
