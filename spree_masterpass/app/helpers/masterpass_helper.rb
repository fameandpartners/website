module MasterpassHelper
  def masterpass_cart_callback_uri(payment_method)
    callback_protocol = Rails.env.production? ? 'https' : 'http'
    masterpass_cart_url(payment_method_id: payment_method.id, protocol: callback_protocol)
  end
end