require 'afterpay/sdk/core/version'

module Afterpay
  module SDK
    module Core
      autoload :VERSION,        'afterpay/sdk/core/version'
      autoload :Config,         'afterpay/sdk/core/config'
      autoload :Configuration,  'afterpay/sdk/core/config'
      autoload :Logging,        "afterpay-sdk/core/logging"
      autoload :BaseDataType,   'afterpay/sdk/core/base_data_type'
      autoload :Exceptions,     'afterpay/sdk/core/exceptions'
      autoload :API,            'afterpay/sdk/core/api'
    end

    class << self
      def configure(options = {}, &block)
        Core::Config.configure(options, &block)
      end

      def load(*args)
        Core::Config.load(*args)
      end

      def logger
        Core::Config.logger
      end

      def logger=(log)
        Core::Config.logger = log
      end
    end

  end
end
