class CreditCardGatewayService

  atrr_reader :order, :user

  def initialize(order, user = nil)
    @order = order
    @user = user
  end

  def gateway
    if Features.active?(:usd_payment_gateway, user)
      @order.available_payment_methods.detect{ |method| method.method_type.eql?('gateway') && method.currency == current_site_version.currency }
    else
      @order.available_payment_methods.detect{ |method| method.method_type.eql?('gateway') }
    end
  end

end
