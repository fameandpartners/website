require_dependency 'spree/calculator'

module Spree
  class Calculator::FreeItem < Calculator
    def self.description
      'Free Product (lower price)'
    end

    # as object we always get line items, as calculable we have Coupon, ShippingMethod
    def compute(object)
      if object.is_a?(Spree::Order)
        quantity = object.legit_line_items.sum(&:quantity)

        promotion = calculable.respond_to?(:promotion) ? calculable.promotion : nil

        if promotion.present?
          rules = promotion.rules.select{ |rule| rule.is_a?(Spree::Promotion::Rules::ItemCount) }
          rule_items_count = rules.map(&:preferred_count).max

          count = (quantity / (rule_items_count + 1))

          prices = object.legit_line_items.map{ |item| [item.price] * item.quantity }.flatten.sort

          amounts = prices.first(count)

          amounts.sum
        else
          BigDecimal.new(0)
        end
      else
        BigDecimal.new(0)
      end
    end
  end
end
