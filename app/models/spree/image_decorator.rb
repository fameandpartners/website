Spree::Image.class_eval do
  after_save do
    viewable.product.try(:update_index) if viewable.is_a?(ProductColorValue)
  end

  after_destroy do
    viewable.product.try(:update_index) if viewable.is_a?(ProductColorValue)
  end

  # Spree's `Spree::Core::S3Support` overrides
  if Rails.application.config.use_s3
    self.attachment_definitions[:attachment]                 = Paperclip::Attachment.default_options
    self.attachment_definitions[:attachment][:styles]        = { product: '240x240>', large: '600x600>' }
    self.attachment_definitions[:attachment][:path]          = 'spree/products/:id/:style/:basename.:extension'
    self.attachment_definitions[:attachment][:default_style] = :product
  end

  # Spree 1.3 `Spree::Image.attachment_definitions[:attachment]` defaults:
  # {
  #   :validations     => [],
  #   :styles          => {
  #     "mini"    => "48x48#",
  #     "small"   => "80x115>",
  #     "product" => "234x336>",
  #     "large"   => "411x590>",
  #     "xlarge"  => "1280x800>",
  #     "email"   => "129x185>"
  #   },
  #   :default_style   => "product",
  #   :url             => ":s3_alias_url",
  #   :path            => "/spree/products/:id/:style/:basename.:extension",
  #   :convert_options => {
  #     :all => "-strip -auto-orient"
  #   },
  #   :storage         => :s3,
  #   :s3_credentials  => {
  #     :access_key_id     => "nothing-to-see-here",
  #     :secret_access_key => "nothing-to-see-here",
  #     :bucket            => "fandp-web-development"
  #   },
  #   :s3_headers      => {
  #     "Cache-Control" => "max-age=31557600"
  #   },
  #   :bucket          => "fandp-web-development",
  #   :default_url     => "/spree/products/:id/:style/:basename.:extension"
  # }
end
