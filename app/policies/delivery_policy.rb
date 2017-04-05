module Policies
  module DeliveryPolicy
    CNY_DELIVERY_PERIOD = '2 weeks'
    FAST_MAKING_DELIVERY_PERIOD = '5 - 7 business days'

    # Max delivery period got from taxons
    def maximum_delivery_period
      return Spree::Taxon::DELIVERY_PERIODS.first unless @product.taxons.any?

      @product.taxons.inject(@product.taxons.first.delivery_period) do |max_period, taxon|
        current_major_value = period_in_business_days(taxon.delivery_period)
        max_major_value = period_in_business_days(max_period)

        current_major_value > max_major_value ? taxon.delivery_period : max_period
      end
    end

    def cny_delivery_period
      CNY_DELIVERY_PERIOD
    end

    def fast_making_delivery_period
      FAST_MAKING_DELIVERY_PERIOD
    end

    # take the maximum_delivery_period then map that to whatever tania says
    def slow_making_delivery_period

    end

    private


    def period_in_business_days(period)
      value = major_value_from_period(period)
      period_units(period) == 'weeks' ? value * 5 : value
    end

    # returns days/weeks from string
    def period_units(period)
      period.match(/(?<=\d\s)[\w\s]+$/).to_s
    end

    # returns the larger number from the range in given string
    def major_value_from_period(period)
      period.match(/\d+(?=\s+\w+|$)/).to_s.to_i
    end
  end
end
