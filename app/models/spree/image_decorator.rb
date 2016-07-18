Spree::Image.class_eval do
  after_save do
    viewable.product.try(:update_index) if viewable.is_a?(ProductColorValue)
  end

  after_destroy do
    viewable.product.try(:update_index) if viewable.is_a?(ProductColorValue)
  end

  # Spree's `Spree::Core::S3Support` overrides
  if Rails.application.config.use_s3
    self.attachment_definitions[:attachment][:storage] = :fog
    self.attachment_definitions[:attachment][:path]    = 'spree/products/:id/:style/:basename.:extension' # Default is `Spree::Config[:attachment_path]`, with value: "/spree/products/:id/:style/:basename.:extension"
  end
end
