# frozen_string_literal: true

module Spree
  # Apple Pay Gateway from Stripe
  class Gateway::ApplePayStripe < Gateway::StripeGateway
    preference :domain_verification_certificate, :text
    preference :currency, :string, description: 'Currency (ISO 4217 - 3 Digits)'
    preference :publishable_key, :string, :description => 'Publishable API Key'

    attr_accessible :preferred_domain_verification_certificate
    attr_accessible :preferred_currency
    attr_accessible :preferred_publishable_key

    DEFAULT_CURRENCY = 'USD'

    def method_type
      'apple_pay_stripe'
    end

    def currency
      preferred_currency.presence || DEFAULT_CURRENCY
    end
  end
end
