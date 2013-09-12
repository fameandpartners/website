Spree::LineItem.class_eval do
  def in_sale?
    old_price.present?
  end

  def amount_without_discount
    old_price * quantity
  end

  def money_without_discount
    Spree::Money.new(amount_without_discount, { :currency => currency })
  end
end
