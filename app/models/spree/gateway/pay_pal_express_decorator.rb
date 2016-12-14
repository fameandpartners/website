Spree::Gateway::PayPalExpress.class_eval do
  DEFAULT_CURRENCY = 'USD'.freeze

  preference :currency, :string

  attr_accessible :preferred_currency

  def currency
    preferred_currency.presence || DEFAULT_CURRENCY
  end
end
