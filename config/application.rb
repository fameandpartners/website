require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

require_relative '../app/middleware/webpack_proxy'

module FameAndPartners
  class Application < Rails::Application
    config.skylight.environments += ['staging']
    config.skylight.alert_log_file = true

    # sidekiq needs lib in eager paths
    config.eager_load_paths += %W( #{config.root}/lib/facebook)
    # [HACK] Replacement for the dotenv-rails gem, was not compatible with spree 1.3
    # [TODO] Remove this and config/envvar.rb when no longer needed
    if Rails.env.test?
      require Rails.root.join('lib', 'envvar', 'envvar')
      Envvar.load Rails.root.join('.env.test')
    end

    if Rails.env.development?
      require Rails.root.join('lib', 'envvar', 'envvar')

      begin
        Envvar.load Rails.root.join('.env')
      rescue Errno::ENOENT => _
        puts '-------WARNING--------'
        puts 'ENV FILE missing. Please, create an ".env" based on ".env.example"'
        puts '----------------------'
      end
    end

    config.to_prepare do
      # manually load some paths
      [
        "../app/**/*_decorator*.rb",
        "../app/overrides/*.rb",
        "../app/services/**/*.rb",
        "../app/repositories/**/*.rb",
        "../app/policies/**/*.rb"
      ].each do |path|
        if Rails.configuration.cache_classes
          Dir.glob(File.join(File.dirname(__FILE__), path)){|c| require(c) }
        else
          Dir.glob(File.join(File.dirname(__FILE__), path)){|c| load(c) }
        end
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{config.root}/lib)
    #config.autoload_paths += Dir[ Rails.root.join('app', 'models') ]
    #config.autoload_paths += Dir[ Rails.root.join('app', 'repositories') ]
    #config.autoload_paths += Dir[ Rails.root.join('app', 'policies') ]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
    # NOTE - If you add or remove an observer during development,
    #        you MUST restart your server, or they won't be loaded.
    config.active_record.observers ||= []
    config.active_record.observers << :fabrication_event_observer
    config.active_record.observers << :item_return_event_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Pacific Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]

    config.i18n.fallbacks = [:en]

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:current_password, :password, :password_confirmation]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.initialize_on_precompile = false

    # Component Style Modal Content
    config.assets.paths << Rails.root.join("app", "assets", 'transient_content')
    config.assets.paths << Rails.root.join("app", "assets", "vendor", "bower_components")

    config.cache_store = :dalli_store, ENV['MEMCACHE_SERVERS'], { namespace: "fandp-#{Rails.env}", expires_in: 1.day, compress: true }

    # Use S3 for storing attachments
    config.use_s3 = false

    config.skip_mail_delivery = false

    config.generators do |generator|
      generator.test_framework :rspec
    end

    config.rspec_paths = []
    config.rspec_paths << self.root

    config.after_initialize do
      Rails.configuration.spree.payment_methods << Spree::Gateway::Pin
      Rails.configuration.spree.payment_methods << Spree::Gateway::NabTransactGateway
      Rails.configuration.spree.payment_methods << Spree::Gateway::AfterpayPayment
      Rails.configuration.spree.payment_methods << Spree::Gateway::FameStripe

      Rails.application.config.spree.calculators.shipping_methods << Spree::Calculator::PriceSackShipping
      Rails.application.config.spree.calculators.shipping_methods << Spree::Calculator::SaleShipping
      Rails.application.config.spree.calculators.tax_rates << Spree::Calculator::CalifornianTaxRate
      Rails.application.config.spree.calculators.promotion_actions_create_adjustments << Spree::Calculator::FreeItem
      Rails.application.config.spree.calculators.promotion_actions_create_adjustments << Spree::Calculator::LowestPriceItemDiscount
      Rails.application.config.spree.calculators.promotion_actions_create_adjustments << Spree::Calculator::PersonalizationDiscount
      Rails.application.config.spree.calculators.promotion_actions_create_adjustments << Spree::Calculator::ProgressivePercents
      Rails.application.config.spree.promotions.rules << Spree::Promotion::Rules::ItemCount
    end

    config.allow_cors = true
    if config.allow_cors
      config.middleware.insert_before 0, "Rack::Cors" do
        allow do
          origins '*'
          resource '*', :headers => :any, :methods => [:get, :post, :put, :options, :delete]
        end
      end
    end

    # Add middleware to proxy requests to react app
    config.paths.add File.join('app', 'middleware'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'middleware', '*')]
    config.middleware.insert_before 0, WebpackProxy, {ssl_verify_none: true}
  end
end
