class CreditCardGatewayService

  attr_reader :order, :currency

  def initialize(order, currency)
    @order = order
    @currency = currency
  end

  def gateway
    @order.available_payment_methods.detect{ |method| method.method_type.eql?('gateway') && method.currency == currency }
  end

end
