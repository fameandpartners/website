Spree::Gateway::PayPalExpress.class_eval do
  DEFAULT_CURRENCY = 'USD'.freeze

  preference :currency, :string

  attr_accessible :preferred_currency

  def currency
    preferred_currency.presence || DEFAULT_CURRENCY
  end

  # some reason the paypal gateway has it's params different than other gateways
  def refund_reparam(refund_amount, item_return)
    payment = Spree::Payment.find_by_order_id(item_return.line_item.order.id)
    Raven.capture_exception(payment.to_json)
    response = self.refund(payment, refund_amount)
    Raven.capture_exception(response.to_json)
    response
  end
end
