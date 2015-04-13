require 'business_time'

module Policies; end

class Policies::OrderProjectedDeliveryDatePolicy

  DELIVERY_DAYS = 7

  attr_reader :order

  def initialize(order)
    @order = order
  end

  def delivery_date
    DELIVERY_DAYS.business_days.after(order.completed_at)
  end

end
