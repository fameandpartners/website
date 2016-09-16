require 'erb'
require 'yaml'

module Afterpay::SDK::Core

  # Include Configuration module to access configuration from any object
  # @example
  #   # Include in any class
  #   include Configuration
  #
  #   # Access config object and attributes
  #   config
  #   config.username
  #
  #   # Change configuration
  #   set_config(:development)
  module Configuration

    # To get default Config object.
    def config
      @config ||= Config.config
    end

    # To change the configuration to given environment or configuration
    # 
    # @param env [Symbol] Environment
    # @param override_configurations [Hash] To override the default configuration.
    # 
    # @example
    #   obj.set_config(api.config)
    #   obj.set_config(:http_timeout => 30)
    #   obj.set_config(:development)
    #   obj.set_config(:development, :http_timeout => 30)
    def set_config(env, override_configurations = {})
      @config =
        case env
        when Config
          env
        when Hash
          begin
            config.dup.merge!(env)
          rescue Errno::ENOENT => error
            Config.new(env)
          end
        else
          Config.config(env, override_configurations)
        end
    end

    alias_method :config=, :set_config
  end

  # Config class is used to hold the configurations.
  # @example
  #   # To load configurations from file
  #   Config.load('config/afterpay.yml', 'development')
  #
  #   # Get configuration
  #   Config.config   # load default configuration
  #   Config.config(:development) # load development configuration
  #   Config.config(:development, :app_id => 'XYZ') # Override configuration
  #
  #   # Read configuration attributes
  #   config = Config.config
  #   config.username
  #   config.endpoint
  class Config

    include Logging
    include Exceptions

    attr_accessor :username, :password,
        :token, :token_secret, :subject,
        :device_ipaddress, :sandbox_email_address,
        :merchant_endpoint,

    alias_method :merchant_end_point=, :merchant_endpoint=
    alias_method :merchant_end_point, :merchant_endpoint

    # Create Config object
    #
    # @param options [Hash] the options to create a config with.
    # @option :username [String] Usename
    # @option :password [String] Password
    #
    # @example
    #   Config.new(username: '123', password: '123456789')
    def initialize(options)
      merge!(options)
    end

    def ssl_options
      @ssl_options ||= {}.freeze
    end

    def ssl_options=(options)
      options = Hash[options.map{|key, value| [key.to_sym, value] }]
      @ssl_options = ssl_options.merge(options).freeze
    end

    # Override configurations
    def merge!(options)
      options.each do |key, value|
        send("#{key}=", value)
      end
      self
    end

    # Validate required configuration
    def required!(*names)
      names = names.select{|name| send(name).nil? }
      raise MissingConfig.new("Required configuration(#{names.join(', ')})") if names.any?
    end

    class << self

      @@config_cache = {}

      # Load configurations from file
      # 
      # @param file_name [String] Configuration file path
      # @param default_environment [String] Default environment configuration to load
      #
      # @example
      #   Config.load('config/afterpay.yml', 'development')
      def load(file_name, default_env = default_environment)
        @@config_cache        = {}
        @@configurations      = read_configurations(file_name)
        @@default_environment = default_env
        config
      end

      # Get default environment name
      def default_environment
        @@default_environment ||= ENV['AFTERPAY_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
      end

      # Set default environment
      def default_environment=(env)
        @@default_environment = env.to_s
      end

      def configure(options = {}, &block)
        begin
          self.config.merge!(options)
        rescue Errno::ENOENT
          self.configurations = { default_environment => options }
        end
        block.call(self.config) if block
        self.config
      end
      alias_method :set_config, :configure

      # Create or Load Config object based on given environment and configurations.
      #
      # @param env [Symbol] Environment name
      # @param override_configuration [Hash] Override the configuration given in file.
      #
      # @example
      #   Config.config
      #   Config.config(:development)
      #   Config.config(:development, { :app_id => 'XYZ' })
      #
      def config(env = default_environment, override_configuration = {})
        if env.is_a? Hash
          override_configuration = env
          env = default_environment
        end
        if override_configuration.nil? or override_configuration.empty?
          default_config(env)
        else
          default_config(env).dup.merge!(override_configuration)
        end
      end

      def default_config(env = nil)
        env = (env || default_environment).to_s
        if configurations[env]
          @@config_cache[env] ||= new(configurations[env])
        else
          raise Exceptions::MissingConfig.new("Configuration[#{env}] NotFound")
        end
      end

      # Set logger
      def logger=(logger)
        Logging.logger = logger
      end

      # Get logger
      def logger
        Logging.logger
      end

      # Get raw configurations in Hash format.
      def configurations
        @@configurations ||= read_configurations
      end

      # Set configuration
      def configurations=(configs)
        @@config_cache   = {}
        @@configurations = configs && Hash[configs.map{|k,v| [k.to_s, v] }]
      end

      private
      # Read configurations from the given file name
      #
      # @param file_name [String] Configuration file path
      def read_configurations(file_name = 'config/afterpay.yml')
        erb = ERB.new(File.read(file_name))
        erb.filename = file_name
        YAML.load(erb.result)
      end

    end

  end
end
