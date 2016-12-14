Spree::Image.class_eval do
  after_save do
    viewable.product.try(:update_index) if viewable.is_a?(ProductColorValue)
  end

  after_destroy do
    viewable.product.try(:update_index) if viewable.is_a?(ProductColorValue)
  end
end
