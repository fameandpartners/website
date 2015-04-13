require 'csv'
require 'active_support/all'
require 'forwardable'
require 'term/ansicolor'

module Products
  class FactoryImporter

    include Term::ANSIColor
    extend Forwardable
    def_delegators :@logger, :info, :debug, :warn, :error, :fatal

    attr_reader :csv_file

    def initialize(csv_file)
      @csv_file = csv_file

      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO unless ENV['debug']
      @logger.formatter = proc do |severity, datetime, _progname, msg|
        color = {'ERROR' => red, 'WARN' => magenta}.fetch(severity) { '' }
        "%s[%s] [%-5s] %s%s\n" % [color, datetime.strftime('%Y-%m-%d %H:%M:%S'), severity, msg, reset]
      end
    end

    def import
      info "Start Factory Import"
      info "File: #{csv_file}"
      csv = CSV.read(csv_file, headers: true, skip_blanks: true)

      Spree::Variant.transaction do
        csv.each do |row|
          sku = row['style'].downcase
          name = row['name']
          factory_name = row['factory']

          info "CSV: sku: #{sku} name: #{name} factory: #{factory_name}"

          variant = Spree::Variant.where(is_master: true).where('lower(sku) = ?', sku).first
          unless variant
            warn "Skipping: No Master variant found for SKU: #{sku}"
            next
          end

          product = variant.product
          old_facty_name = product.property(:factory_name)

          if product.set_property(:factory_name, factory_name)
            info "#{green("OK")} Set Factory #{old_facty_name} -> #{factory_name}"
          end
        end
      end
      info "Done"
    end
  end
end
