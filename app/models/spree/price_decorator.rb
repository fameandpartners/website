Spree::Price.class_eval do
  attr_accessible :price

  def apply(discount)
    return nil if (discount.nil? || discount.amount.to_i <= 0)
    amount_with_discount = self.amount * (100 - discount.size.to_i) / 100
    Spree::Price.new(amount: amount_with_discount, currency: self.currency)
  end
end
