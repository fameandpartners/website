require_relative 'delivery_policy'

module Policies
  class LineItemDeliveryPolicy
    include DeliveryPolicy

    def initialize(line_item)
      @line_item = line_item
      @product = @line_item.product
    end

    def delivery_period
      # chinese new years wins out over all
      if Features.active?(:cny_delivery_delays)
        cny_delivery_period      
      elsif @line_item.fast_making? #then the fast_making wins
        fast_making_delivery_period
      elsif @line_item.slow_making? #how slow can you go
        slow_making_delivery_period
      else
        maximum_delivery_period
      end
    end
  end
end
