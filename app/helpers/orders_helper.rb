module OrdersHelper
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
end
