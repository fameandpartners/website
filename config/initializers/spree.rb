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

  config.products_per_page = 100 # disable pagination at all
  config.allow_backorders = true # allow order items out of stock - we have 90% items by order
  config.show_zero_stock_products = true

  config.attachment_styles = {
    'mini' => '48x48#',
    'small' => '83x115#',
    'product' => '243x352#',
    'large' => '460x590#',
    'xlarge' => '1280x800>'
  }.to_json

  config.currency = 'AUD'

  config.allow_checkout_on_gateway_error = false

  config.default_country_id = Spree::Country.find_by_iso('AU').try(:id)

  config.checkout_zone = 'Australia'

  config.emails_sent_from = 'noreply@fameandpartners.com'
end

Spree.user_class = "Spree::User"

Spree::Ability.register_ability(Blog::Ability)
