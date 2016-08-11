Spree::ShipmentMailer.class_eval do

  def shipped_email(shipment, resend = false)
    begin
      shipment        = shipment.is_a?(Spree::Shipment) ? shipment : Spree::Shipment.find(shipment)
      subject         = shipped_email_subject(spree_shipment: shipment, resend: resend)
      order_presenter = Marketing::OrderPresenter.new(shipment.order)

      Marketing::CustomerIOEventTracker.new.track(
        order_presenter.user,
        'shipment_mailer',
        email_to:              order_presenter.email,
        from:                  'noreply@fameandpartners.com',
        subject:               subject,
        date:                  Date.today.to_s(:long),
        name:                  order_presenter.first_name.rstrip,
        shipment_method_name:  order_presenter.shipment_method_name,
        line_items:            order_presenter.build_line_items,
        shipment_tracking:     order_presenter.shipment_tracking,
        shipment_tracking_url: order_presenter.shipment_tracking_url,
        billing_address:       order_presenter.billing_address,
        shipping_address:      order_presenter.shipping_address,
        phone:                 order_presenter.phone,
        delivery_date:         order_presenter.projected_delivery_date,
        original_order_date:   order_presenter.original_order_date,
        display_item_total:    order_presenter.display_item_total,
        display_total:         order_presenter.display_total,
        auto_account:          order_presenter.auto_account,
        order_number:          order_presenter.number,
        currency:              order_presenter.currency,
        shipping_amount:       order_presenter.shipping_amount,
        tax:                   nil,
        adjustments:           order_presenter.build_adjustments
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
    subject += "Hey babe, your dress is on it's way - Order: ##{spree_shipment.order.number}"
    subject
  end
end
