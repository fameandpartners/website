# frozen_string_literal: true

module Spree
  # Apple Pay Gateway from Stripe
  class Gateway::ApplePayStripe < Gateway::StripeGateway
    preference :domain_verification_certificate, :text
    preference :currency, :string, description: 'Currency (ISO 4217 - 3 Digits)'

    attr_accessible :preferred_domain_verification_certificate
    attr_accessible :preferred_currency

    DEFAULT_CURRENCY = 'USD'

    def method_type
      'apple_pay_stripe'
    end

    def currency
      preferred_currency.presence || DEFAULT_CURRENCY
    end
  end
end
