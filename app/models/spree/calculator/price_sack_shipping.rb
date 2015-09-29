require_dependency 'spree/calculator'
require_dependency 'spree/sale'

module Spree
  class Calculator::PriceSackShipping < Calculator
    
    preference :minimal_amount, :decimal, :default => 0
    preference :normal_amount, :decimal, :default => 0
    preference :discount_amount, :decimal, :default => 0
    preference :currency, :string, :default => Spree::Config[:currency]

    attr_accessible :preferred_minimal_amount,
                    :preferred_normal_amount,
                    :preferred_discount_amount,
                    :preferred_currency


    def self.description
      'Price sack on total order amount'
    end

    # as object we always get line items, as calculable we have Coupon, ShippingMethod
    def compute(object)
      if object.is_a?(Array)
        base = object.map { |o| get_object_base(o) }.sum
      else
        base = get_object_base(object)
      end

      if base < self.preferred_minimal_amount || has_items_in_sale?(object)
        self.preferred_normal_amount
      else
        self.preferred_discount_amount
      end
    end

    def get_object_base(object)
      if object.is_a?(Spree::Order)
        order_total_without_shipment(object)
      elsif object.respond_to?(:amount) 
        object.amount
      else
        BigDecimal(object.to_s) 
      end
    end

    def order_total_without_shipment(order)
      if order.shipment.present?
        order.total - order.shipment.amount
      else
        order.amount # items total, without promotions
      end
    rescue
      order.amount # items total
    end

    def has_items_in_sale?(object)
      return false if object.blank? || !object.respond_to?(:in_sale?)
      object.in_sale?
    end

  end
end
