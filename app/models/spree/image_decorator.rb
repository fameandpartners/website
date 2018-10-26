Spree::Image.class_eval do
  # NOTE: this change affects Paperclip global configuration
  if Rails.application.config.use_s3
    self.attachment_definitions[:attachment][:storage] = :fog
    self.attachment_definitions[:attachment][:path]    = 'spree/products/:id/:style/:basename.:extension'
  end

  self.attachment_definitions[:attachment][:styles] = {
    xxxlarge: '4048x4048>', 
    xxlarge: '2816x2816>', 
    xlarge: '2024x2024>',
    large: '1408x1408>', 
    medium: '1056x1056>', 
    small: '704x704>',
    xsmall: '528x528>',
    xxsmall: '352x352>',
    product: '704x704>',
  }
end
