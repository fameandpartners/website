Spree::Image.class_eval do
  after_save do
    viewable.product.try(:update_index) if viewable.is_a?(ProductColorValue)
  end

  after_destroy do
    viewable.product.try(:update_index) if viewable.is_a?(ProductColorValue)
  end

  # NOTE: this change affects Paperclip global configuration
  if Rails.application.config.use_s3
    self.attachment_definitions[:attachment][:storage] = :fog
    self.attachment_definitions[:attachment][:path]    = 'spree/products/:id/:style/:basename.:extension'
  end
end
