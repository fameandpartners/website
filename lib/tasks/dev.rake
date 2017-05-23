namespace :dev do
  desc 'Get a completely clean slate, no cache, no assets, no images, no elasticsearch index.'
  task clean_slate: %w(assets:clean cache:expire elasticsearch:reindex)

  desc 'Enable Test Payment Gateways'
  task enable_payment_gateways: :environment do
    require 'log_formatter'
    class EnablePaymentGateways

      attr_reader :logger, :target_env

      def initialize(logdev: $stdout, target_env:)
        @target_env = %w(test development).include?(target_env) ? target_env : 'development'
        @logger = Logger.new(logdev)
        @logger.formatter = LogFormatter.terminal_formatter
      end

      def call
        unless Rails.env.development?
          logger.error "Only runs in development environment not (#{Rails.env})"
          return
        end

        logger.info 'Disabling Production Gateways'
        Spree::PaymentMethod.all.map do |gw|
          logger.info "Disabling #{gw.name.ljust(30)} (#{gw.provider_class})"
          gw.active = false
          gw.save
        end

        logger.info 'Deleting current Test Gateways'
        Spree::PaymentMethod.where("name ILIKE '%TEST%'").destroy_all

        # PIN
        logger.info 'Creating Test PIN Payment'

        pin_payment                           = Spree::Gateway::Pin.new
        pin_payment.name                      = 'PIN Payments TEST'
        pin_payment.preferred_api_key         = 'LElcjB_z4BItXJQPYlw43g' # Sandbox API keys
        pin_payment.preferred_publishable_key = 'pk_iaPOLVAQMh7nTJ0WhECpUA' # Sandbox API keys
        pin_payment.preferred_server          = 'test'
        pin_payment.environment               = target_env
        pin_payment.active                    = true
        pin_payment.save

        # Afterpay
        logger.info 'Creating Test Afterpay Payment'

        afterpay_payment                    = Spree::Gateway::AfterpayPayment.new
        afterpay_payment.name               = 'Afterpay Australia TEST'
        afterpay_payment.preferred_username = '32935' # Sandbox API Keys
        afterpay_payment.preferred_password = '249c235938f36015bb32571721ba2dc80257d2fe985799c30a0e5877408991b596b117d998e0528a7872103f8fc80e07d71163c801b22153149ac6a0919b588a' # Sandbox API Keys
        afterpay_payment.preferred_server   = 'sandbox'
        afterpay_payment.environment        = target_env
        afterpay_payment.active             = true
        afterpay_payment.save
      end
    end

    target_env = ENV.fetch('TARGET_ENV') { nil }

    EnablePaymentGateways.new(target_env: target_env).call
  end

  desc 'Add Test Fixtures User'
  task add_test_fixture_user: :environment do
    Spree::User.new.tap do |user|
      user.first_name                 = 'Example'
      user.last_name                  = 'User'
      user.email                      = 'spree@example.com'
      user.password                   = '123456'
      user.password_confirmation      = '123456'
      user.skip_welcome_email         = true
      user.validate_presence_of_phone = false
    end.save

    admin = Spree::User.new.tap do |user|
      user.first_name                 = 'Example'
      user.last_name                  = 'Admin'
      user.email                      = 'admin@example.com'
      user.password                   = '123456'
      user.password_confirmation      = '123456'
      user.skip_welcome_email         = true
      user.validate_presence_of_phone = false
    end
    admin.save
    admin.spree_roles << Spree::Role.find_by_name('admin')
  end

  desc 'Disable all feature flags'
  task disable_feature_flags: :environment do
    Features.available_features.each { |feature| Features.deactivate(feature) }
  end

  desc 'Add Fixture Tax Rates'
  task enable_fixture_tax_rates: :environment do
    require 'term/ansicolor'
    include Term::ANSIColor

    usa_zone     = Spree::Zone.where(name: 'usa').first
    tax_category = Spree::TaxCategory.where(
      name:        'USA Taxes',
      description: 'USA Taxes'
    ).first_or_create

    raise red('[WARNING] USA Zone does not exist. Aborting Rake') if usa_zone.nil?

    # Destroying existent taxes
    Spree::TaxRate.destroy_all

    # Californian Tax
    Spree::TaxRate.create({
      zone_id:            usa_zone.id,
      tax_category_id:    tax_category.id,
      name:               'California Tax',
      amount:             0.075,
      included_in_price:  false,
      show_rate_in_label: false,
      calculator:         Spree::Calculator::CalifornianTaxRate.new
    })
  end
end
