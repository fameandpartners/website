require 'business_time'

module Policies

  class OrderProjectedDeliveryDatePolicy

    DELIVERY_DAYS = 7
    FAST_DELIVERY_DAYS = 2

    attr_reader :order

    def initialize(order)
      @order = order
    end

    # note - possible, this should be order.line_items.map(&:projected_delivery_date).min
    def delivery_date
      if order.has_fast_making_items?
        FAST_DELIVERY_DAYS.business_days.after(order.completed_at)
      else
        DELIVERY_DAYS.business_days.after(order.completed_at)
      end
    end
  end
end
