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

  def show_order_adjustment_total(order)
    content_tag('span', order.currency) + ' ' + order.display_adjustment_total
  end

  def show_order_shipment_total(order)
    if order.shipment && order.shipment.display_amount && order.shipment.display_amount.money.cents > 0
      content_tag('span', order.currency) + order.shipment.display_amount
    else
      'Free'
    end
  end

  def shipment_tracking_url(shipment)
    return '#' if shipment.blank?
    if shipment.is_dhl?
      "http://www.dhl.com/content/g0/en/express/tracking.shtml?brand=DHL&AWB=#{ shipment.tracking }%0D%0A"
    elsif shipment.is_auspost?
      "http://auspost.com.au/track/track.html?id=#{ shipment.tracking }"
    elsif shipment.is_tnt?
      "http://www.tnt.com/webtracker/tracking.do?respCountry=us&respLang=en&navigation=1&page=1&sourceID=1&sourceCountry=ww&plazaKey=&refs=&requesttype=GEN&searchType=CON&cons=#{ shipment.tracking }"
    end
  end
end
