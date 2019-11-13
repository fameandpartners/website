# frozen_string_literal: true

module Spree
  # Apple Pay helper method for Order
  module ApplePayOrderDecorator
    def paid_with_apple_pay?
      payments.valid.any?(&:apple_pay?)
    end
  end
end

Spree::Order.prepend Spree::ApplePayOrderDecorator
