namespace :dev do
  desc 'Get a completely clean slate, no cache, no assets, no images, no elasticsearch index.'
  task clean_slate: %w(assets:clean cache:expire elasticsearch:reindex)

  desc 'Enable Test Payment Gateways'
  task enable_payment_gateways: :environment do
    require 'log_formatter'
    class EnablePaymentGateways

      attr_reader :logger

      def initialize(logdev: $stdout)
        @logger = Logger.new(logdev)
        @logger.formatter = LogFormatter.terminal_formatter
      end

      def call
        unless Rails.env.development?
          logger.error "Only runs in development environment (#{Rails.env})"
          return
        end

        test_gateway_names = ['PIN Payments TEST']

        logger.info "Disabling Production Gateways"
        Spree::PaymentMethod.all.map do |gw|
          logger.info "Disabling #{gw.name.ljust(22)} (#{gw.provider.class.name})"
          gw.active = false
          gw.save
        end

        logger.info "Enabling Test Gateways"

        Spree::PaymentMethod.where(:name => test_gateway_names).map do |gw|
          logger.info "Enabling #{gw.name.ljust(22)} (#{gw.provider.class.name})"
          gw.active = true
          gw.environment = Rails.env.to_s
          gw.save
        end
      end
    end
    EnablePaymentGateways.new.call
  end
end
