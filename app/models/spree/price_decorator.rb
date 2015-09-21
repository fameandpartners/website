Spree::Price.class_eval do
  attr_accessible :price

  def apply(discount)
    return nil if (discount.nil? || discount.amount.to_i <= 0)
    amount_with_discount = self.amount * (100 - discount.size.to_i) / 100
    Spree::Price.new(amount: amount_with_discount, currency: self.currency)
  end

  def to_spree_price
    self
  end

  # if new currency == old, return self
  # if old currency == default, convert directly
  # if old currency != default, use cross-course
  # NOTE: price exchange rates stored in site version, and relative to default currency
  def convert_to(new_currency)
    return self if new_currency.blank? || self.currency == new_currency

    rate = SiteVersion.get_exchange_rate(currency, new_currency)
    if rate.present? 
      Spree::Price.new(amount: self.amount ? self.amount * rate : nil, currency: new_currency)
    else
      self
    end
  end
end
