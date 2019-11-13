# frozen_string_literal: true

module Spree
  # Apple Pay helper method for Payment
  module ApplePayPaymentDecorator
    def apple_pay?
      payment_method.is_a? Spree::Gateway::ApplePayStripe
    end
  end
end

Spree::Payment.prepend Spree::ApplePayPaymentDecorator
