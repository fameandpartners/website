Spree::ShipmentMailer.class_eval do
  add_template_helper(OrdersHelper)

  def shipped_email(shipment, resend = false)
    @shipment = shipment.is_a?(Spree::Shipment) ? shipment : Spree::Shipment.find(shipment)
    subject = (resend ? "[#{t(:resend).upcase}] " : '')
    subject += "Hey babe, your dress is on it's way - Order: ##{@shipment.order.number}"
    mail(:to => @shipment.order.email, :from => from_address, :subject => subject)
  end
end
