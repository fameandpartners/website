FameAndPartners::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Open sent mails in browser
  config.action_mailer.delivery_method = :letter_opener

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  config.action_mailer.asset_host = 'http://localhost:3000'

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

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

  Rails.application.middleware.use( Oink::Middleware, :logger => Rails.logger )
end
