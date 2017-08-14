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

      billing_addy = gateway_options[:billing_address]
      shipping_addy = gateway_options[:shipping_address]

      charge = Stripe::Charge.create(
        amount: money,
        currency: preferred_currency.downcase,
        description: gateway_options[:description] + ", #{billing_addy[:name]}",

        source: creditcard[:gateway_payment_profile_id],
        metadata: {
          billing_city: billing_addy[:city],
          billing_country: billing_addy[:country],
          billing_line1: billing_addy[:address1],
          billing_line2: billing_addy[:address2],
          billing_state: billing_addy[:state],
          billing_zip: billing_addy[:zip],
          billing_country: billing_addy[:country],
          name: billing_addy[:name],
          email: gateway_options[:email],
          ip_address: gateway_options[:ip],
          order: gateway_options[:order_id]
        },

        receipt_email: gateway_options[:email],
        shipping: {
          address: { #shipping address
            city: shipping_addy[:city],
            country: shipping_addy[:country],
            line1: shipping_addy[:address1],
            line2: shipping_addy[:address2],
            postal_code: shipping_addy[:zip],
            state: shipping_addy[:state],
          },
          name: shipping_addy[:name],
          phone: shipping_addy[:phone]
        }
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

  def refund(amount, payment_code, gateway_options = {})
    Stripe.api_key = self.preferred_api_key

    resp = Stripe::Refund.create(
      charge: payment_code,
      amount: amount
    )

    resp
  end

  def auto_capture?
    true
  end
end
