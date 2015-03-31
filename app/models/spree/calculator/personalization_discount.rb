require_dependency 'spree/calculator'

module Spree
  class Calculator::PersonalizationDiscount < Calculator
    preference :custom_size_discount, :decimal, default: 100
    preference :custom_color_discount, :decimal, default: 100
    preference :customizations_discount, :decimal, default: 100

    attr_accessible :preferred_custom_size_discount,
                    :preferred_custom_color_discount,
                    :preferred_customizations_discount

    def self.description
      'Personalizations Discounts'
    end

    # as object we always get line items, as calculable we have Coupon, ShippingMethod
    def compute(object)
      if object.is_a?(Array)
        return if object.empty?
        order = object.first.order
      else
        order = object
      end 

      result = 0.0
      order.line_items.includes(:personalization).each do |line_item|
        next if line_item.personalization.blank?

        result += line_item.personalization.size_cost * size_discount
        result += line_item.personalization.color_cost * color_discount
        result += line_item.personalization.customizations_cost * customizations_discount
      end

      # return negative value - we decreasing order price
      - result.abs
    end 

    private

      def size_discount
        @size_discount ||= convert_percents_to_float(preferred_custom_size_discount)
      end

      def color_discount
        @color_discount ||= convert_percents_to_float(preferred_custom_color_discount)
      end

      def customizations_discount
        @customizations_discount ||= convert_percents_to_float(preferred_customizations_discount)
      end

      def convert_percents_to_float(raw_value)
        if raw_value >= 0 && raw_value <= 100
          raw_value.to_i / 100.0
        else
          0
        end
      end
  end
end
