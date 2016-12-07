class CreditCardGatewayService

  attr_reader :order, :currency

  def initialize(order, currency)
    @order    = order
    @currency = currency
  end

  def gateway
    @gateway ||= find_gateway
  end

  def find_gateway
    available_gateways = order.available_payment_methods.select { |pm| pm.method_type == 'gateway' }
    default_gateway    = available_gateways.first
    currency_gateway   = available_gateways.find { |gateway| gateway.currency == currency }

    currency_gateway.presence || default_gateway
  end
end
