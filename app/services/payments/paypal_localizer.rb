module Payments
  class PaypalLocalizer

    attr_reader :order, :currency

    def initialize(order, currency)
      @order    = order
      @currency = currency
    end

    def gateway
      @gateway ||= find_localized_paypal
    end

    def find_localized_paypal
      available_gateways = order.available_payment_methods.select { |pm| pm.type == 'Spree::Gateway::PayPalExpress' }
      default_gateway    = available_gateways.first
      currency_gateway   = available_gateways.find { |gateway| gateway.currency == currency }

      currency_gateway.presence || default_gateway
    end
  end
end
