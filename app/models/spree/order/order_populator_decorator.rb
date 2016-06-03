Spree::OrderPopulator.class_eval do

  def populate(from_hash)
    @line_item_ids = []
    from_hash[:products].each do |product_id,variant_id|
      attempt_cart_add(variant_id, from_hash[:quantity])
    end if from_hash[:products]

    from_hash[:variants].each do |variant_id, quantity|
      attempt_cart_add(variant_id, quantity)
    end if from_hash[:variants]

    valid? ? @line_item_ids : false
  end

  private

  def attempt_cart_add(variant_id, quantity)
    quantity = quantity.to_i
    if quantity > Spree::Config[:max_quantity]
      errors.add(:base, I18n.t(:please_enter_reasonable_quantity, :scope => :order_populator))
      return false
    end

    variant = Spree::Variant.find(variant_id)
    if quantity > 0
      if check_stock_levels(variant, quantity)
        @line_item_ids << @order.add_variant(variant, quantity, currency).id
        @order.restart_checkout_flow
      end
    end
  end

end
