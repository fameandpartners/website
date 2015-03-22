require 'forwardable'
require 'term/ansicolor'

module BatchUpload
  class ImagesUploader

    include Term::ANSIColor

    extend Forwardable
    def_delegators :@logger, :info, :debug, :warn, :error, :fatal

    attr_reader :ok

    def initialize(location, strategy = :update)
      @_strategies = [:update, :delete]
      @_expiration = 6.hours

      @_location = location
      unless @_strategies.include?(strategy)
        raise "Undefined strategy name! Select between #{@_strategies.to_sentence}"
      else
        @_strategy = strategy
      end

      @ok = green("OK").freeze
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO unless ENV['debug']
      @logger.formatter = proc do |severity, datetime, _progname, msg|
        color = severity == 'ERROR' ? red : ''
        "%s[%s] [%-5s] %s%s\n" % [color, datetime.strftime('%Y-%m-%d %H:%M:%S'), severity, msg, reset]
      end
    end

    private

    def each_product &block
      get_list_of_directories(@_location).each do |path|
        info '-' * 25
        name = path.rpartition('/').last.strip

        info "Process directory \"#{name}\" "

        matches = Regexp.new('(?<sku>[[:alnum:]]+)[\-_]?', true).match(name)

        if matches.blank?
          error "Directory name is invalid"
          next
        end

        sku = matches[:sku].downcase.strip
        product = Spree::Variant.
          where(deleted_at: nil, is_master: true).
          where('LOWER(TRIM(sku)) = ?', sku).
          order('id DESC').first.try(:product)

        if product.blank?
          error "Product not found for SKU: #{sku}"
          next
        else
          info "Product: SKU: #{sku}, NAME: #{product.name} ID: #{product.id}"
        end

        block.call(product, path)
      end
    end

    def get_list_of_files(location)
      paths_for(location).select do |path|
        File.file?(path)
      end
    end

    def get_list_of_directories(location)
      paths_for(location).select do |path|
        File.directory?(path)
      end
    end

    def paths_for(location)
      Dir.glob(File.join(location, '*'))
    end

    def success(type, attributes = {})
      attrs = attributes.collect { |k,v| "#{k}=#{v}" }.join(' ')
      info "#{type} #{ok}: #{attrs}"
    end
  end
end
