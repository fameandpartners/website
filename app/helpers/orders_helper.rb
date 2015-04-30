module OrdersHelper
  
  def order_status(order)
    t("order_fabrication_states.#{order.fabrication_status}")
  end
  
  # Order state is a spree setting that conveys no useful information
  def order_state(order)
    state = order.state.present? ? order.state : 'pending'
    t("order_states.#{state}")
  end

  def order_payment_state(order)
    state = order.payment_state.present? ? order.payment_state : 'pending'
    t("payment_states.#{state}")
  end
  
  def order_shipment_state(order)
    state = order.shipment_state.present? ? order.shipment_state : 'pending'
    t("shipment_states.#{state}")
  end

  def show_order_adjustment_total(order)
    content_tag('span', order.currency) + ' ' + order.display_adjustment_total
  end

  def show_order_promotion_total(order)
    content_tag('span', order.currency) + ' ' + order.display_promotion_total
  end

  def show_order_shipment_total(order)
    if order.shipment && order.shipment.display_amount && order.shipment.display_amount.money.cents > 0
      content_tag('span', order.currency) + order.shipment.display_amount
    else
      'Free Shipping'
    end
  end

  def shipment_tracking_url(shipment)
    return '#' if shipment.blank?
    raw shipment.tracking_url
  end
end
