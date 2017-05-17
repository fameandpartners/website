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

      retval = ''

      case units
      when 'weeks'
        retval = order.completed_at + value.weeks
      when 'days'
        retval = order.completed_at + value.days
      when 'business days'
        retval = value.business_days.after(order.completed_at)
      end

      retval.to_date
    end

    # returns period with 2 numbers and a unit
    # eq 3 - 4 weeks, 12 - 14 business days etc
    # this should only be called for manual orders which can only contain 1 line item
    def delivery_period
      # period = ''

      # if order.has_fast_making_items?
      #   return Policies::DeliveryPolicy::FAST_MAKING_DELIVERY_PERIOD
      # elsif order.has_slow_making_items?
      #   period = Policies::DeliveryPolicy::SLOW_MAKING_DELIVERY_MAP[maximal_delivery_period]
      # else
      #   period = maximal_delivery_period
      # end

      # # make adjustment for chinese new year
      # if Features.active?(:cny_delivery_delays)
      #   period = adjust_for_cny(period)
      # end
      order.line_items.first.delivery_period
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
