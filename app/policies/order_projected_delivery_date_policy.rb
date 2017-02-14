require 'business_time'

module Policies

  class OrderProjectedDeliveryDatePolicy

    DELIVERY_DAYS = 10
    FAST_DELIVERY_DAYS = 4
    DELAY_DELIVERY_DAYS = 28

    attr_reader :order

    def initialize(order)
      @order = order
    end

    def delivery_date
      if Features.active?(:cny_delivery_delays)
        order.completed_at + DELAY_DELIVERY_DAYS.days
      elsif order.has_fast_making_items?
        FAST_DELIVERY_DAYS.business_days.after(order.completed_at)
      else
        # get maximum from line items delivery periods
        maximal_delivery_period.business_days.after(order.completed_at)
      end
    end

    private

    def maximal_delivery_period
      order.line_items.
        map(&:product).map(&:delivery_period).
        map { |period| major_value_from_period(period) }.
        max
    end

    private

    def major_value_from_period(period)
      period.match(/(?<=\s)\d+/).to_s.to_i
    end
  end
end
