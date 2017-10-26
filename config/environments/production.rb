FameAndPartners::Application.configure do

  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  config.action_controller.asset_host = ENV['RAILS_ASSET_HOST']

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( storefront.js application_redesign.css main_nav_widget.css html5.js ie.css widgets/site_navigations.css quiz.css quiz.js application_contentful.css application_contentful.js application_returns.js application_returns.css application_custom_experience.js application_custom_experience.css)

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = true

  app_host_without_protocol = ENV['APP_HOST'].to_s.gsub('https://', '').gsub('http://', '')
  config.action_mailer.default_url_options = { host: app_host_without_protocol, protocol: 'https' }

  # config.action_mailer.asset_host = ENV['RAILS_ASSET_HOST']
  config.action_mailer.asset_host = 'https://www.fameandpartners.com' # TODO: hardcoded for the moment

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Use S3 for storing attachments
  config.use_s3 = true

  config.skip_mail_delivery = ENV['SKIP_MAIL_DELIVERY'] == 'true'
end
