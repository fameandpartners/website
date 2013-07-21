class Spree::Gateway::Pin < Spree::Gateway
  preference :api_key, :string

  attr_accessible :preferred_api_key

  def auto_capture?
    true
  end

  def void(response_code, gateway_options)
    provider.refund(nil, response_code)
  end

  def provider_class
    ActiveMerchant::Billing::PinGateway
  end
end
