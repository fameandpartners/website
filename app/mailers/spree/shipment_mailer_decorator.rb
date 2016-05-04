Spree::ShipmentMailer.class_eval do
  add_template_helper(OrdersHelper)

  def shipped_email(shipment, resend = false)
    shipment        = shipment.is_a?(Spree::Shipment) ? shipment : Spree::Shipment.find(shipment)
    subject         = shipped_email_subject(spree_shipment: shipment, resend: false)
    order_presenter = Orders::OrderPresenter.new(shipment.order, shipment.line_items)
    line_items      = order_presenter.extract_line_items
    Marketing::CustomerIOEventTracker.new.track(
      shipment.order.user,
      'shipment_mailer',
      email_to:              shipment.order.email,
      from:                  'noreply@fameandpartners.com',
      subject:               subject,
      date:                  Date.today.to_s(:long),
      name:                  order_presenter.first_name.rstrip,
      shipment_method_name:  shipment.shipping_method.name,
      line_items:            line_items,
      shipment_tracking:     shipment.tracking,
      shipment_tracking_url: shipment.blank? ? '#' : shipment.tracking_url
    )
  end

  private def shipped_email_subject(spree_shipment:, resend:)
    subject = (resend ? "[#{t(:resend).upcase}] " : '')
    subject += "Hey babe, your dress is on it's way - Order: ##{spree_shipment.order.number}"
    subject
  end
end
