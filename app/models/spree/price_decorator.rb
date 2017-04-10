Spree::Price.class_eval do
  attr_accessible :price

  def apply(discount)
    discount_size = discount&.size.to_f

    if discount_size > 0
      amount_with_discount = self.amount * (1 - discount_size / 100)
      Spree::Price.new(amount: amount_with_discount, currency: self.currency)
    else
      self
    end
  end
end
