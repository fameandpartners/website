require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module FameAndPartners
  class Application < Rails::Application

    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # Load application's view overrides
      Dir.glob(File.join(File.dirname(__FILE__), "../app/overrides/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      Dir.glob(File.join(File.dirname(__FILE__), "../app/services/**/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      Dir.glob(File.join(File.dirname(__FILE__), "../app/repositories/**/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # note: load reports manually
      #Dir.glob(File.join(File.dirname(__FILE__), "../app/reports/**/*.rb")) do |c|
      #  Rails.configuration.cache_classes ? require(c) : load(c)
      #end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir[ Rails.root.join('app', 'models') ]
    config.autoload_paths += Dir[ Rails.root.join('app', 'repositories') ]
    config.autoload_paths += Dir[ Rails.root.join('app', 'policies') ]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
    config.active_record.observers ||= []
    config.active_record.observers << :fabrication_event_observer
    config.active_record.observers << :activity_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]

    config.i18n.fallbacks = [:en]

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    disable_warnings = true
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.initialize_on_precompile = false

    # Component Style Modal Content
    config.assets.paths << Rails.root.join("app", "assets", 'transient_content')

    redis_namespace = ['fame_and_partners', Rails.env, 'cache'].join('_')
    if Rails.env.production? || Rails.env.preproduction?
      redis_host = YAML::load(File.open("#{Rails.root}/config/redis.yml"))[Rails.env][:hosts]
    else
      redis_host = 'localhost:6379'
    end

    config.cache_store = :redis_store, "redis://#{redis_host}/0/#{redis_namespace}"

    # Use S3 for storing attachments
    config.use_s3 = false

    config.skip_mail_delivery = false

    config.generators do |generator|
      generator.test_framework :rspec
    end

    config.after_initialize do
      Rails.configuration.spree.payment_methods << Spree::Gateway::Pin
      Rails.configuration.spree.payment_methods << Spree::Gateway::NabTransactGateway

      Rails.application.config.spree.calculators.shipping_methods << Spree::Calculator::PriceSackShipping
      Rails.application.config.spree.calculators.shipping_methods << Spree::Calculator::SaleShipping
      Rails.application.config.spree.calculators.promotion_actions_create_adjustments << Spree::Calculator::FreeItem
      Rails.application.config.spree.calculators.promotion_actions_create_adjustments << Spree::Calculator::LowestPriceItemDiscount
      Rails.application.config.spree.calculators.promotion_actions_create_adjustments << Spree::Calculator::PersonalizationDiscount
      Rails.application.config.spree.calculators.promotion_actions_create_adjustments << Spree::Calculator::ProgressivePercents
      Rails.application.config.spree.promotions.rules << Spree::Promotion::Rules::ItemCount
      Rails.application.config.spree.promotions.rules << Spree::Promotion::Rules::BridesmaidsCount
      Rails.application.config.spree.promotions.rules << Spree::Promotion::Rules::BridesmaidPartyMember
    end

    config.allow_cors = true
    if config.allow_cors
      config.middleware.insert_before 0, "Rack::Cors" do
        allow do
          origins '*'
          resource '*', :headers => :any, :methods => [:get, :post, :options]
        end
      end
    end
  end
end
