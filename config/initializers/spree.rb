# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  # Example:
  # Uncomment to override the default site name.
  # config.site_name = "Fame & Partners"
  config.allow_ssl_in_production = true
  config.allow_ssl_in_staging = false

  config.products_per_page = 1000 # disable pagination at all
  config.allow_backorders = false # allow order items out of stock - we have 90% items by order
  config.show_zero_stock_products = true

  config.attachment_styles = {
    mini:     '48x48#',
    small:    '80x115>',
    product:  '234x336>',
    large:    '411x590>',
    xlarge:   '1280x800>',
    email:    '129x185>'
  }.to_json

  config.currency = 'AUD'

  config.allow_checkout_on_gateway_error = false

  begin
    config.default_country_id = Spree::Country.find_by_iso('AU').try(:id)
  rescue Exception => e
    Rails.logger.warn e.message
  end

  config.checkout_zone = 'Australia'

  config.emails_sent_from = 'Fame And Partners<noreply@fameandpartners.com>'

  if Rails.application.config.use_s3
    config.use_s3 = true
    config.s3_bucket = configatron.aws.s3.bucket
    config.s3_access_key = configatron.aws.s3.access_key_id
    config.s3_secret = configatron.aws.s3.secret_access_key

    config.attachment_url = ":s3_alias_url"
    config.attachment_path = '/spree/products/:id/:style/:basename.:extension'
  else
    config.use_s3 = false

    config.attachment_url = '/spree/products/:id/:style/:basename.:extension'
    config.attachment_path = ':rails_root/public/spree/products/:id/:style/:basename.:extension'
  end
end

Spree::Ability.register_ability(OrderProcessingAbility)
Spree::Ability.register_ability(CustomerServiceAbility)
Spree::Ability.register_ability(Blog::Ability)

Devise::RegistrationsController.layout "redesign/application"

Spree.user_class = "Spree::User"

Spree::SocialConfig[:path_prefix] = 'user'

if Spree::Config.use_s3
  # filesystem storage uses path pattern, but s3 storage requires smt like s3_alias_url here
  Spree::Image.attachment_definitions[:attachment][:url] = Paperclip::Attachment.default_options[:url]
end

Spree::AppConfiguration.class_eval do
  preference :free_customisations, :boolean, :default => false
end
