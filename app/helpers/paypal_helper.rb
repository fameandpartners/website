module PaypalHelper
  def paypal_payment_method
    @paypal_payment_method ||= Spree::PaymentMethod.where(
      type: "Spree::Gateway::PayPalExpress",
      environment: Rails.env,
      active: true,
      deleted_at: nil
    ).first
  end

  def paypal_available?
    paypal_payment_method.present?
  end

  def paypal_express_button
    return if paypal_payment_method.blank?

    url = paypal_express_url(payment_method_id: paypal_payment_method.id, protocol: request.protocol)
    link_to(
      image_tag('https://www.paypalobjects.com/webstatic/en_US/i/buttons/checkout-logo-large.png'),
      url, method: :post, id: "paypal_button"
    )
  end    

  def guest_paypal_express_button
    return if paypal_payment_method.blank?

    url = guest_paypal_express_url(payment_method_id: paypal_payment_method.id, protocol: request.protocol)
    link_to(
      image_tag("https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif"),
      url, method: :post, id: "paypal_button"
    )
  end
end
