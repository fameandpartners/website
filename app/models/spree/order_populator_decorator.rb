Spree::OrderPopulator.class_eval do
  attr_accessor :populate_personalized

  def attempt_cart_add(variant_id, quantity)
    quantity = quantity.to_i
    if quantity > Spree::Config[:max_quantity]
      errors.add(:base, I18n.t(:please_enter_reasonable_quantity, :scope => :order_populator))
      return false
    end 

    variant = Spree::Variant.find(variant_id)

    # ignore count on hand.
    if self.populate_personalized
      variant.on_hand = variant.on_hand <= 0 ? 1 : variant.on_hand + 1
      variant.save
    end

    if quantity > 0 
      if check_stock_levels(variant, quantity)
        @order.add_variant(variant, quantity, currency)
      end 
    end 
  end 
end
