require_dependency 'spree/calculator'

module Spree
  class Calculator::CalifornianTaxRate < Calculator
    def self.description
      'Californian Tax Calculator'.freeze
    end

    # Default tax calculator still needs to support orders for legacy reasons
    # Source: https://github.com/spree-contrib/spree_tax_cloud/blob/3f72d65d3536fff95b1d658855b2b5d64d3c629b/app/models/spree/calculator/tax_cloud_calculator.rb#L7-L9
    def compute(computable)
      case computable
        when Spree::Order
          compute_order(computable)
        when Spree::LineItem
          compute_line_item(computable)
      end
    end

    private

    def rate
      self.calculable
    end

    def shipping_to_california?(order)
      country_name = order.ship_address.try(:country).try(:iso3)
      state_name   = order.ship_address.try(:state).try(:name)
      country_name == 'USA' && state_name == 'California'
    end

    def compute_order(order)
      if shipping_to_california?(order)
        adjustment_total = order.adjustments.eligible\
                            .delete_if { |a| a.originator&.calculator == self }\
                            .map(&:amount)\
                            .sum

        item_total       = order.line_items.reject{|x| x.product.name.downcase == 'return_insurance'}.map(&:amount).sum
        order_total      = item_total + adjustment_total

        round_to_two_places(order_total * rate.amount)
      else
        0
      end
    end

    def compute_line_item(line_item)
      if shipping_to_california?(line_item.order)
        round_to_two_places(line_item.total * rate.amount)
      else
        0
      end
    end

    def round_to_two_places(amount)
      BigDecimal.new(amount.to_s).round(2, BigDecimal::ROUND_HALF_UP)
    end
  end
end
