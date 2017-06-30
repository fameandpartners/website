class Spree::Gateway::Thanhpay < Spree::Gateway
  require 'stripe'

  preference :api_key, :string, :description => 'Secret API Key'
  preference :publishable_key, :string, :description => 'Publishable API Key'
  preference :currency, :string, :description => 'Currency (ISO 4217 - 3 Digits)'

  attr_accessible :preferred_api_key
  attr_accessible :preferred_publishable_key
  attr_accessible :preferred_currency

  DEFAULT_CURRENCY = 'USD'.freeze

  def provider_class
    Spree::Gateway::Thanhpay
  end

  def payment_source_class
    Spree::CreditCard
  end

  # def method_type
  #   'stripe'
  # end

  def purchase(money, creditcard, gateway_options)
    binding.pry
    ActiveMerchant::Billing::Response.new(true, 'success', {}, {})
    # if token = creditcard.gateway_payment_profile_id
    #   # The Balanced ActiveMerchant gateway supports passing the token directly as the creditcard parameter
    #   creditcard = token
    # end

    # provider.purchase(money, creditcard, gateway_options)
  end

  def currency
    preferred_currency.presence || DEFAULT_CURRENCY
  end

  def auto_capture?
    true
  end

  # def void(response_code, gateway_options)
  #   provider.refund(nil, response_code)
  # end

  # no refund for you!
  # def refund(amount, payment_code, gateway_options = {})
  # end

end
