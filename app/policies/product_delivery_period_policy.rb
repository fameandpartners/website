require_relative 'delivery_policy'

module Policies
  class ProductDeliveryPeriodPolicy
    include DeliveryPolicy

    def initialize(product)
      @product = product
    end

    def delivery_period
      if Features.active?(:cny_delivery_delays)
        cny_delivery_period
      else
        maximum_delivery_period
      end
    end
  end
end
