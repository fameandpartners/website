module MasterpassHelper
  def masterpass_cart_callback_uri(payment_method)
    callback_protocol = Rails.env.production? ? 'https' : 'http'
    masterpass_cart_url(payment_method_id: payment_method.id, protocol: callback_protocol)
  end

  def masterpass_payment_method
    @masterpass_payment_method ||= Spree::PaymentMethod.where(
        type: "Spree::Gateway::Masterpass",
        # environment: Rails.env,
        active: true,
        deleted_at: nil
    ).first
  end

  def masterpass_available?
    masterpass_payment_method.present?
  end
end