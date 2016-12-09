module ProductActivityReport
  module_function

  def total_product_viewed(product_id)
    action_count :viewed, product_id
  end

  def total_product_added_to_cart(product_id)
    action_count :added_to_cart, product_id
  end

  def total_product_added_to_wishlist(product_id)
    action_count :added_to_wishlist, product_id
  end

  def total_product_purchased(product_id)
    action_count :purchased, product_id
  end

  def action_count(action, product_id)
    0
  end

end
