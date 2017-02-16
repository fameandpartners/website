module Policies
  module DeliveryPolicy
    CNY_DELIVERY_PERIOD = '2 - 3 weeks'
    FAST_MAKING_DELIVERY_PERIOD = '4 - 6 business days'

    # Max delivery period got from taxons
    def maximum_delivery_period
      return Spree::Taxon::DELIVERY_PERIODS.first unless @product.taxons.any?

      @product.taxons.inject(@product.taxons.first.delivery_period) do |max_period, taxon|
        current_major_value = major_value_from_period(taxon.delivery_period)
        max_major_value = major_value_from_period(max_period)

        current_major_value > max_major_value ? taxon.delivery_period : max_period
      end
    end

    def cny_delivery_period
      CNY_DELIVERY_PERIOD
    end

    def fast_making_delivery_period
      FAST_MAKING_DELIVERY_PERIOD
    end

    private

    def major_value_from_period(period)
      period.match(/(?<=\s)\d+/).to_s.to_i
    end
  end
end
