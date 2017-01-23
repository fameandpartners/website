module Policies
  class ProductDeliveryPeriodPolicy
    CNY_DELIVERY_PERIOD = '3 - 4 weeks'

    def initialize(product)
      @product = product
    end

    def delivery_period
      if Features.active?(:cny_delivery_delays)
        CNY_DELIVERY_PERIOD
      else
        minimum_delivery_period
      end
    end

    # Min delivery period got from taxons
    def minimum_delivery_period
      return Spree::Taxon::DELIVERY_PERIODS.first unless @product.taxons.any?

      @product.taxons.inject(@product.taxons.first.delivery_period) do |min_period, taxon|
        current_major_value = major_value_from_period(taxon.delivery_period)
        min_major_value = major_value_from_period(min_period)

        current_major_value < min_major_value ? taxon.delivery_period : min_period
      end
    end

    private

    def major_value_from_period(period)
      period.match(/(?<=\s)\d+/).to_s.to_i
    end
  end
end
