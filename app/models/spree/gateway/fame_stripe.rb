class Spree::Gateway::FameStripe < Spree::Gateway
  require 'stripe'

  preference :api_key, :string, :description => 'Secret API Key'
  preference :publishable_key, :string, :description => 'Publishable API Key'
  preference :currency, :string, :description => 'Currency (ISO 4217 - 3 Digits)'

  attr_accessible :preferred_api_key
  attr_accessible :preferred_publishable_key
  attr_accessible :preferred_currency

  DEFAULT_CURRENCY = 'USD'.freeze

  def provider_class
    Spree::Gateway::FameStripe
  end

  def payment_source_class
    Spree::CreditCard
  end

  def purchase(money, creditcard, gateway_options)
    begin
      Stripe.api_key = self.preferred_api_key

      charge = Stripe::Charge.create(
        :amount => money,
        :currency => preferred_currency.downcase,
        :description => gateway_options[:description],
        :source => creditcard[:gateway_payment_profile_id]
      )

      resp = ActiveMerchant::Billing::Response.new(true, 'success', {}, {})
      resp.authorization = charge.id
      resp
    rescue Stripe::CardError => e
      ActiveMerchant::Billing::Response.new(false, e.json_body[:error][:message], {}, {})
    rescue => e
      NewRelic::Agent.notice_error(e)
      Raven.capture_exception(e)
      raise
    end
  end

  def currency
    preferred_currency.presence || DEFAULT_CURRENCY
  end

  def auto_capture?
    true
  end
end
