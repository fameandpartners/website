class Spree::Gateway::Pin < Spree::Gateway
  preference :api_key, :string, :description => 'Secret API Key'
  preference :publishable_key, :string, :description => 'Publishable API Key'
  preference :currency, :string, :description => 'Currency (ISO 4217 - 3 Digits)'

  attr_accessible :preferred_api_key
  attr_accessible :preferred_publishable_key
  attr_accessible :preferred_currency

  USD_GATEWAYS = [
    ENV['PINS_USD_GATEWAY_1'],
    ENV['PINS_USD_GATEWAY_2']
  ]

  def purchase(money, creditcard, gateway_options)
    if token = creditcard.gateway_payment_profile_id
      # The Balanced ActiveMerchant gateway supports passing the token directly as the creditcard parameter
      creditcard = token
    end
    provider.purchase(money, creditcard, gateway_options)
  end

  # TODO: 6th December 2016 - `#currency_through_env_keys` is deprecated, and should be deleted after all PIN payment methods have a currency preference
  def currency
    preferred_currency.presence || currency_through_env_keys
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

  private

  def currency_through_env_keys
    if USD_GATEWAYS.include?(preferred_publishable_key)
      'USD'
    else
      'AUD'
    end
  end
end
