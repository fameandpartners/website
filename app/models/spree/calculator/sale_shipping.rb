require_dependency 'spree/calculator'
require_dependency 'spree/sale'

module Spree
  class Calculator::SaleShipping < Calculator

    preference :sale_products_shipping_amount,    :decimal, :default => 11.70
    preference :normal_products_shipping_amount,  :decimal, :default => 0
    preference :international_shipping_fee,       :decimal, :default => 30.0

    attr_accessible :preferred_sale_products_shipping_amount,
      :preferred_normal_products_shipping_amount, :preferred_international_shipping_fee

    def self.description
      'Flat rate dependent on having sale/not sale products'
    end

    def compute(object)
      shipping_amount = if has_items_in_sale?(object) || promotion_require_shipping_charge?(object)
                          self.preferred_sale_products_shipping_amount
                        else
                          self.preferred_normal_products_shipping_amount
                        end

      zone_member = object.try(:shipping_address).try(:country).try(:zone_member)
      shipping_fee = zone_member && zone_member.has_international_shipping_fee ? self.preferred_international_shipping_fee : 0
      shipping_amount + shipping_fee
    end

    def has_items_in_sale?(object)
      return false if object.blank? || !object.respond_to?(:in_sale?)
      object.in_sale?
    end

    def promotion_require_shipping_charge?(object)
      return false if object.blank? || !object.respond_to?(:coupon_code_added_promotion)
      promotion = object.coupon_code_added_promotion
      promotion.present? && promotion.require_shipping_charge?
    end
  end
end
