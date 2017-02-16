module Policies
  class ProductDeliveryPeriodPolicy
    CNY_DELIVERY_PERIOD = '3 - 4 weeks'
    FAST_MAKING_DELIVERY_PERIOD = '4 - 6 business days'

    def initialize(product)
      @product = product
    end

    def delivery_period
      if Features.active?(:cny_delivery_delays)
        CNY_DELIVERY_PERIOD
      else
        maximum_delivery_period
      end
    end

    # Max delivery period got from taxons
    def maximum_delivery_period
      return Spree::Taxon::DELIVERY_PERIODS.first unless @product.taxons.any?

      @product.taxons.inject(@product.taxons.first.delivery_period) do |max_period, taxon|
        current_major_value = major_value_from_period(taxon.delivery_period)
        max_major_value = major_value_from_period(max_period)

        current_major_value > max_major_value ? taxon.delivery_period : max_period
      end
    end

    private

    def major_value_from_period(period)
      period.match(/(?<=\s)\d+/).to_s.to_i
    end
  end
end
