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
  config.allow_ssl_in_production = !!ENV.fetch('SPREE_SSL_IN_PRODUCTION') { false }
  config.allow_ssl_in_staging = false
  config.allow_ssl_in_development_and_test = Features.active?(:force_sitewide_ssl)
  if RUBY_PLATFORM =~ /mswin|mingw|cygwin/i
    config.allow_ssl_in_development_and_test = false
  end

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
end

Devise::RegistrationsController.layout "redesign/application"

Spree.user_class = "Spree::User"

Spree::SocialConfig[:path_prefix] = 'user'
