##
# with enabled fast_making option, items in cart can have different delivery dates
#
# usage:
#   LineItemProjectedDeliveryDatePolicy.new(item, order).delivery_date
#
require 'business_time'

module Policies
  class LineItemProjectedDeliveryDatePolicy
    DELIVERY_DAYS = 7
    FAST_DELIVERY_DAYS = 2

    attr_reader :line_item, :order

    def initialize(line_item, order = nil)
      @line_item  = line_item
      @order      = order || line_item.order
    end

    def delivery_date
      if line_item.fast_making?
        FAST_DELIVERY_DAYS.business_days.after(order.completed_at)
      else
        DELIVERY_DAYS.business_days.after(order.completed_at)
      end
    end
  end
end
