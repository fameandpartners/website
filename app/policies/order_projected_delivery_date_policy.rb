require 'business_time'

module Policies

  class OrderProjectedDeliveryDatePolicy

    attr_reader :order

    def initialize(order)
      @order = order
    end

    def delivery_date
      period = delivery_period
      value = major_value_from_period(period)
      units = period_units(period)

      case units
      when 'weeks'
        order.completed_at + value.weeks
      when 'days'
        order.completed_at + value.days
      when 'business days'
        value.business_days.after(order.completed_at)
      end
    end

    # returns period with 2 numbers and a unit
    # eq 3 - 4 weeks, 12 - 14 business days etc
    def delivery_period
      if Features.active?(:cny_delivery_delays)
        Policies::DeliveryPolicy::CNY_DELIVERY_PERIOD
      elsif order.has_fast_making_items?
        Policies::DeliveryPolicy::FAST_MAKING_DELIVERY_PERIOD
      else
        maximal_delivery_period
      end
    end

    private

    # returns period with 2 numbers and a unit
    # eq 3 - 4 weeks, 12 - 14 business days etc
    def maximal_delivery_period
      order.line_items.
        map(&:delivery_period).
        max { |period1, period2| period_in_business_days(period1) <=> period_in_business_days(period2) }
    end

    def period_in_business_days(period)
      value = major_value_from_period(period)
      period_units(period) == 'weeks' ? value * 5 : value
    end

    def period_units(period)
      period.match(/(?<=\d\s)[\w\s]+$/).to_s
    end

    def major_value_from_period(period)
      period.match(/(?<=\s)\d+/).to_s.to_i
    end
  end
end
