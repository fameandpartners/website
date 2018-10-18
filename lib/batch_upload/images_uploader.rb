require 'forwardable'
require 'term/ansicolor'
require_relative '../log_formatter'

module BatchUpload
  class ImagesUploader

    include Term::ANSIColor

    extend Forwardable
    def_delegators :@logger, :info, :debug, :warn, :error, :fatal

    attr_reader :ok

    def initialize(location, strategy = :update)
      @_strategies = [:update, :delete]
      @_expiration = 2.minutes

      @_location = location
      unless @_strategies.include?(strategy)
        raise "Undefined strategy name! Select between #{@_strategies.to_sentence}"
      else
        @_strategy = strategy
      end

      @ok = green("OK").freeze
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO unless ENV['debug']
      @logger.formatter = LogFormatter.terminal_formatter
    end

    private

    def each_product &block
      directories = get_list_of_directories(@_location)
      total_directories = directories.size
      parent = File.basename @_location
      directories.each_with_index do |path, idx|
        if ENV['PARAM1'].present? && File.basename(path)!~/#{ENV['PARAM1']}/i
          puts "Images Folder SKIP #{path}"
          next
        else
          puts "Images Folder TAKE #{path}"
        end
        info '-' * 25
        name = File.basename path

        info "Directory (#{idx + 1}/#{total_directories}): #{parent}/ #{bold(name)}"

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
          error "Product not found for SKU: #{sku} DIR: #{name}"
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
      attrs = attributes.collect { |k,v| "#{k}=#{bright_white(v.to_s)}" }.join(' ')
      info "#{type} #{ok}: #{attrs}"
    end

    def test_run?
      false
    end
  end
end
