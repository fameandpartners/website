require_dependency 'spree/calculator'

module Spree
  class Calculator::ProgressivePercents < Calculator
    preference :dresses_nums,     :string, default: '3,5'
    preference :discount_amounts, :string, default: '15,20,25'

    attr_accessible :preferred_dresses_nums, :preferred_discount_amounts


    def self.description
      'Progressive Percents'
    end

    def compute(object)
      if object.is_a?(Spree::Order)
        quantity = order_items_num(object)

        available_discounts = []
        discount_ranges.each do |num, discount|
          available_discounts.push(discount) if quantity >= num.to_i
        end

        discount = available_discounts.max
        object.amount * discount / 100
      else
        BigDecimal.new(0)
      end
    end

    private

    def order_items_num(order)
      order.line_items.sum(:quantity)
    end

    # returns [0, 15], [3, 20], [5, 25]
    def discount_ranges
      dresses_nums.zip(discount_amounts)
    end

    def dresses_nums
      @dresses_num ||= begin
        result = preferred_dresses_nums.split(/[\s,]/).map(&:to_i)
        if result.size < discount_amounts.size
          result.unshift(0)
        end
        result
      end
    end

    def discount_amounts
      @discount_amounts ||= preferred_discount_amounts.split(',').map(&:to_i)
    end
  end
end
