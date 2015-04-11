require 'business_time'

module Services; end

class Services::OrderProjectedDeliveryDateService

  DELIVERY_DAYS = 7

  attr_reader :order

  def initialize(order)
    @order = order
  end

  def project_date
    order.update_attributes!(:projected_delivery_date => delivery_date)
  end

  def delivery_date
    DELIVERY_DAYS.business_days.after(order.completed_at)
  end

end
