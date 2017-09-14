FameAndPartners::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false
  config.action_controller.perform_caching = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Open sent mails in browser
  config.action_mailer.delivery_method = :letter_opener

  app_host_without_protocol = ENV['APP_HOST'].to_s.gsub('https://', '').gsub('http://', '')
  config.action_mailer.default_url_options = { host: app_host_without_protocol }

  config.action_mailer.asset_host = 'http://localhost:3000'

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = ENV.fetch('DEVELOPMENT_ASSETS_COMPRESS', 'false') == 'true'

  # Expands the lines which load the assets
  config.assets.debug = ENV.fetch('DEVELOPMENT_ASSETS_DEBUG', 'true') == 'true'

  # Use S3 for storing attachments
  config.use_s3 = true

  Slim::Engine.set_options :pretty => true, :sort_attrs => false

  # reloading
  config.to_prepare do
    Spree::Product.send(:include, Overrides::Spree::Product)
  end

  # enable sourcemaps for easier css debugging in chrome
  config.sass.debug_info = true
  config.sass.line_comments = false # source maps don't get output if this is true

  # Force React-Rails components to be reloaded on Dev mode.
  config.watchable_dirs.merge!( { Rails.root.join("/app/assets/javascripts/**/*.jsx.*") => ['jsx']})

  # Bullet
  config.after_initialize do
    Bullet.enable        = ENV.fetch('BULLET_ENABLE', 'false') == 'true'
    Bullet.bullet_logger = true
    Bullet.console       = true
    Bullet.rails_logger  = true
    Bullet.add_footer    = true
  end

  # NOTE: Alexey Bobyrev 15/12/16
  # Better errors for running in container/VM
  BetterErrors::Middleware.allow_ip! '0.0.0.0/0'
end
