require 'erb'
require 'yaml'

module Iequalchange

  # Include Configuration module to access configuration from any object
  # @example
  #   # Include in any class
  #   include Configuration
  #
  #   # Access config object and attributes
  #   config
  #   config.iec_id
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
    #   obj.set_config(:development)
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
  #   Config.load('config/iequalchange.yml', 'development')
  #
  #   # Get configuration
  #   Config.config   # load default configuration
  #   Config.config(:development) # load development configuration
  #
  #   # Read configuration attributes
  #   config = Config.config
  #   config.iec_id
  #   config.key
  class Config
    attr_accessor :enabled, :iec_id, :iec_key, :iec_url

    # Create Config object
    #
    # @param options [Hash] the options to create a config with.
    # @option :iec_key [String] Key
    # @option :iec_id [String] ID
    #
    # @example
    #   Config.new(iec_id: '123', ien_key: '123456789', enabled: true)
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
      #   Config.load('config/iequalchange.yml', 'development')
      def load(file_name, default_env = default_environment)
        @@config_cache        = {}
        @@configurations      = read_configurations(file_name)
        @@default_environment = default_env
        config
      end

      # Get default environment name
      def default_environment
        @@default_environment ||= ENV['IEC_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
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
      def read_configurations(file_name = 'config/iequalchange.yml')
        erb = ERB.new(File.read(file_name))
        erb.filename = file_name
        YAML.load(erb.result) || {}
      end

    end

  end
end
