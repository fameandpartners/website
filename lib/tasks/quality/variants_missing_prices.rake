namespace :quality do
  desc 'Find Variants which are missing prices for currencies we support, and automagically fix them. Control logging with LOG_LEVEL='
  task :fix_variants_missing_prices => :environment do
    class VariantMissingPriceEnforcer

      attr_reader :logger

      JUST_ENOUGH_PRICES = 2

      def initialize(logdev: $stdout)
        @logger = Logger.new(logdev)
        @logger.level = Logger.const_get(ENV.fetch("LOG_LEVEL", "INFO"))
        @logger.formatter = LogFormatter.terminal_formatter
      end

      def scope
        Spree::Product.active.includes(:variants => [:prices])
      end

      def call
        logger.info "Started"
        states = []

        scope.each do |product|

          prices_attributes = product.master.prices.collect {|p| [p.currency, p.amount] }.uniq.to_h

          if product.variants.all? { |v| v.prices.count == JUST_ENOUGH_PRICES }
            logger.debug [
                           'OK',
                           product.sku.to_s.ljust(10),
                           product.name.to_s.ljust(20),
                           prices_attributes.map {|c,a| "#{c}=#{a}"}.join(', ')
                         ].join (' | ')
            states << :skip_product
            next
          end

          states << :update_product

          logger.warn "#{product.name} - Setting Prices"

          unless product.master.prices.count == JUST_ENOUGH_PRICES
            logger.warn "#{product.name} - MASTER has (#{product.master.prices.count}) PRICES"
          end

          unless prices_attributes.key? 'USD'
            prices_attributes['USD'] = prices_attributes['AUD']
            logger.warn "#{product.name} - MASTER has No USD Price"
          end

          product.variants_including_master.each do |variant|
            next if variant.prices.count == JUST_ENOUGH_PRICES
            states << :update_variant

            log_prefix = "#{product.name} #{variant.sku.to_s.ljust(30)}"

            variant.prices.each do |p|
              logger.debug "#{log_prefix} :: OLD PRICE: #{p.currency} #{p.amount}"
            end

            prices_attributes.each do |currency, amount|
              existing_price = variant.prices.detect { |p| p.currency == currency }

              next if existing_price
              logger.info "#{log_prefix} | Create Price: #{currency} #{amount}"
              variant.prices.create(currency: currency, amount: amount)

            end
          end
        end

        states.group_by {|x| x}.map { |k,v| [k,v.count]}.map { |state, count |
          logger.info "Action | #{state}: #{count}"
        }

        logger.info "Done"
      end
    end
    VariantMissingPriceEnforcer.new.call
  end
end
