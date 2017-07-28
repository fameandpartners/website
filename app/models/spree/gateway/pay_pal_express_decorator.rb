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
    self.refund(payment, refund_amount)
  end
end
