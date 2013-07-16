FameAndPartners::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

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

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  Slim::Engine.set_default_options :pretty => true, :sort_attrs => false

  # reloading
  config.to_prepare do
    Spree::User.send(:include, Overrides::SpreeAuthDevise::User)
    Spree::User.send(:include, Overrides::Spree::Product)
  end
end
