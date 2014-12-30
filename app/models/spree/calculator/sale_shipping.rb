require_dependency 'spree/calculator'
require_dependency 'spree/sale'

module Spree
  class Calculator::SaleShipping < Calculator

    preference :sale_products_shipping_amount,    :decimal, :default => 11.70
    preference :normal_products_shipping_amount,  :decimal, :default => 0

    attr_accessible :preferred_sale_products_shipping_amount,
      :preferred_normal_products_shipping_amount

    def self.description
      'Flat rate dependent on having sale/not sale products'
    end

    # as object we always get line items, as calculable we have Coupon, ShippingMethod
    def compute(object)
      if has_items_in_sale?(object)
        self.preferred_sale_products_shipping_amount
      else
        self.preferred_normal_products_shipping_amount
      end
    end

    def has_items_in_sale?(object)
      return false if object.blank? || !object.respond_to?(:in_sale?)
      object.in_sale?
    end
  end
end
