class CreditCardGatewayService

  attr_reader :order, :currency, :user

  def initialize(order, currency, user = nil)
    @order = order
    @currency = currency
    @user = user
  end

  def gateway
    if Features.active?(:usd_payment_gateway, user)
      @order.available_payment_methods.detect{ |method| method.method_type.eql?('gateway') && method.currency == currency }
    else
      @order.available_payment_methods.detect{ |method| method.method_type.eql?('gateway') && method.currency == 'AUD'}
    end
  end

end
