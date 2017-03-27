Spree::Price.class_eval do
  attr_accessible :price

  def apply(discount)
    if discount&.amount.to_i > 0
      amount_with_discount = self.amount * (1 - discount.size.to_f / 100)
      Spree::Price.new(amount: amount_with_discount, currency: self.currency)
    end
  end
end
