require_dependency 'spree/calculator'

module Spree
  class Calculator::LowestPriceItemDiscount < Calculator
    preference :discount,     :decimal, default: 0
    preference :items_count,  :integer, default: 1

    attr_accessible :preferred_discount, :preferred_items_count

    def self.description
      'Discount for product(s) with lower price'
    end

    def compute(object)
      if object.is_a?(Array)
        return if object.empty?
        order = object.first.order
      else
        order = object
      end 

      - lowest_items_cost(order) * normalized_discount
    end

    private

      def lowest_items_cost(order)
        items_prices = order.line_items.collect do |item|
          [item.price] * item.quantity
        end.flatten
        items_count = normalized_items_count(items_prices.size)
        items_prices.sort.first(items_count).sum
      end

      def normalized_discount
        value = preferred_discount
        if value >= 0 && value <= 100
          value / 100
        else
          BigDecimal.new(0)
        end
      end

      # not more than order items total
      def normalized_items_count(order_items)
        return 1 if preferred_items_count.to_i <= 0
        return 0 if order_items <= 1
        (preferred_items_count.to_i >= order_items) ? (order_items - 1) : preferred_items_count.to_i
      end
  end
end
