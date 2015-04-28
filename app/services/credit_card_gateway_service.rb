class CreditCardGatewayService

  attr_reader :order, :currency

  def initialize(order, currency)
    @order = order
    @currency = currency
  end

  def gateway
    @gateway ||= find_gateway
  end

  def find_gateway
    @order.available_payment_methods.detect{ |method| method.method_type.eql?('gateway') && method.currency == currency } || @order.available_payment_methods.detect{ |method| method.method_type.eql?('gateway') }
  end
end
