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

    attr_reader :completed_at, :fast_making

    def initialize(completed_at, fast_making)
      @completed_at = completed_at
      @fast_making = fast_making
    end

    def delivery_date
      if fast_making
        FAST_DELIVERY_DAYS.business_days.after(completed_at)
      else
        DELIVERY_DAYS.business_days.after(completed_at)
      end
    end
  end
end
