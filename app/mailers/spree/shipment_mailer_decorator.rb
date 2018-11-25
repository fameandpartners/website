Spree::ShipmentMailer.class_eval do

  def shipped_email(shipment, resend = false)
    begin
      shipment        = shipment.is_a?(Spree::Shipment) ? shipment : Spree::Shipment.find(shipment)
      subject         = shipped_email_subject(spree_shipment: shipment, resend: resend)
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
        shipment_method_name:  shipment.try(:shipping_method).try(:name),
        line_items:            line_items,
        shipment_tracking:     shipment.tracking,
        shipment_tracking_url: shipment.blank? ? '#' : shipment.tracking_url,
        billing_address:       shipment.order.try(:billing_address).to_s.presence || 'No Billing Address',
        shipping_address:      shipment.order.try(:shipping_address).to_s.presence || 'No Shipping Address',
        phone:                 shipment.order.try(:billing_address).try(:phone) || 'No Phone',
        original_order_date:   shipment.order.created_at.strftime("%d %b %Y"),
        display_item_total:    shipment.order.display_item_total.to_s,
        display_total:         shipment.order.display_total.to_s,
        auto_account:          shipment.order.user && shipment.order.user.automagically_registered?,
        order_number:          shipment.order.number,
        currency:              shipment.order.currency,
        shipping_amount:       shipment.order.adjustments.where(label: "Shipping").first.try(:amount).to_s,
        tax:                   nil
      )
    rescue Customerio::Client::InvalidResponse => e
      response = HashWithIndifferentAccess[e.response.to_hash]
      response[:body] = e.response.body
      Raven.capture_exception(e, extra: { response: response })
      NewRelic::Agent.notice_error(e)
    rescue StandardError => e
      Raven.capture_exception(e)
      NewRelic::Agent.notice_error(e)
    end
  end

  private def shipped_email_subject(spree_shipment:, resend:)
    subject = (resend ? "[#{t(:resend).upcase}] " : '')
    subject += "Hey babe, your dress is on its way - Order: ##{spree_shipment.order.number}"
    subject
  end
end
