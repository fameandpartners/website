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

        test_gateway_names = ['PIN Payments TEST', 'Afterpay Australia TEST']

        logger.info "Disabling Production Gateways"
        Spree::PaymentMethod.all.map do |gw|
          logger.info "Disabling #{gw.name.ljust(30)} (#{gw.provider_class})"
          gw.active = false
          gw.save
        end

        logger.info "Enabling Test Gateways"

        Spree::PaymentMethod.where(:name => test_gateway_names).map do |gw|
          logger.info "Enabling #{gw.name.ljust(30)} (#{gw.provider_class})"
          gw.active      = true
          gw.environment = target_env
          gw.save
        end
      end
    end

    target_env = ENV.fetch('TARGET_ENV') { nil }

    EnablePaymentGateways.new(target_env: target_env).call
  end

  desc 'Add Test Fixtures User'
  task :add_test_fixture_user => :environment do
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
  task :disable_feature_flags => :environment do
    Features.available_features.each { |feature| Features.deactivate(feature) }
  end
end
