require 'business_time'
require_relative 'delivery_policy'

module Policies
  class LineItemDeliveryPolicy
    include DeliveryPolicy

    def initialize(line_item)
      @line_item = line_item
      @product = @line_item.product
    end

    def delivery_period
      period = ''

      if @line_item.fast_making? #fast_making wins
        return fast_making_delivery_period
      elsif @line_item.slow_making? #how slow can you go
        period = slow_making_delivery_period
      elsif @line_item.super_fast_making?
        period = super_fast_making_delivery_period
      else
        period = maximum_delivery_period
      end

      # make adjustment for chinese new year
      if Features.active?(:cny_delivery_delays)
        period = adjust_for_cny(period)
      end

      period
    end
  end
end
