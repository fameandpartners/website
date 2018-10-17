Spree::Image.class_eval do
  # NOTE: this change affects Paperclip global configuration
  if Rails.application.config.use_s3
    self.attachment_definitions[:attachment][:storage] = :fog
    self.attachment_definitions[:attachment][:path]    = 'spree/products/:id/:style/:basename.:extension'
  end
end
