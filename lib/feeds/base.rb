require_relative './exporter/base'
require_relative './exporter/cpc'
require_relative './exporter/polyvore'

module Feeds
  class Base
    FEEDS =  %w(CPC Polyvore)

    attr_reader :config, :current_site_version, :logger

    def initialize(version_permalink, logger: default_logger)
      @current_site_version = SiteVersion.by_permalink_or_default(version_permalink)
      @logger = logger

      @config = {
        title:       'Fame & Partners',
        description: 'Fame & Partners our formal dresses are uniquely inspired pieces that are perfect for your formal event, school formal or prom.',
        domain:       URI.join("http://#{ActionMailer::Base.default_url_options[:host]}", @current_site_version.to_param).to_s
      }
    end

    def default_logger
      logger = Logger.new($stdout)

      logger.formatter = LogFormatter.terminal_formatter
      logger
    end

    def export
      @logger.info "Starting Feeds Export SITE (#{current_site_version.permalink})"
      @items = Spree::Product.active

      FEEDS.each do |name|
        logger.info("START Feed #{name}")
        klass                         = Feeds::Exporter.const_get(name)
        exporter                      = klass.new(logger: @logger)
        exporter.items                = @items
        exporter.config               = @config
        exporter.current_site_version = @current_site_version
        exporter.export
        logger.info("END Feed #{name}")
      end
    end

    def self.export!(version)
      base = new(version)
      base.export
    end
  end
end
