class Spree::Gateway::Pin < Spree::Gateway
  preference :api_key, :string, :description => 'Secret API Key'
  preference :publishable_key, :string, :description => 'Publishable API Key'

  attr_accessible :preferred_api_key
  attr_accessible :preferred_publishable_key

  USD_GATEWAYS = configatron.pin_payments.usd_gateways

  def purchase(money, creditcard, gateway_options)
    if token = creditcard.gateway_payment_profile_id
      # The Balanced ActiveMerchant gateway supports passing the token directly as the creditcard parameter
      creditcard = token
    end
    provider.purchase(money, creditcard, gateway_options)
  end

  def currency
    if USD_GATEWAYS.include?(preferred_publishable_key)
      'USD'
    else
      'AUD'
    end
  end

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
