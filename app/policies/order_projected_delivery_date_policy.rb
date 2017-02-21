require 'business_time'
require_relative 'delivery_policy'

module Policies
  class OrderProjectedDeliveryDatePolicy
    include DeliveryPolicy

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
  end
end
