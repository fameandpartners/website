##
# with enabled fast_making option, items in cart can have different delivery dates
#
# usage:
#   LineItemProjectedDeliveryDatePolicy.new(item, order).delivery_date
# thanh - deprecating this junk
require 'business_time'

module Policies
  class LineItemProjectedDeliveryDatePolicy
    DELIVERY_DAYS = 7
    FAST_DELIVERY_DAYS = 4

    attr_reader :order_completed_at, :fast_making

    def initialize(order_completed_at, fast_making)
      @order_completed_at = order_completed_at
      @fast_making = fast_making
    end

    def delivery_date
      if fast_making
        FAST_DELIVERY_DAYS.business_days.after(order_completed_at)
      else
        DELIVERY_DAYS.business_days.after(order_completed_at)
      end
    end
  end
end
