Spree::Image.class_eval do
  after_save do
    viewable.product.try(:update_index) if viewable.is_a?(ProductColorValue)
  end

  after_destroy do
    viewable.product.try(:update_index) if viewable.is_a?(ProductColorValue)
  end

  # Spree's `Spree::Core::S3Support` overrides
  self.attachment_definitions[:attachment][:storage] = :fog
  self.attachment_definitions[:attachment][:path]    = 'spree/products/:id/:style/:basename.:extension'
end
