require 'logger'

module Afterpay::SDK::Core
  module Logging

    def logger
      @logger ||= Logging.logger
    end

    def log_event(message, &block)
      start_time = Time.now
      block.call
    ensure
      logger.info sprintf("[%.3fs] %s", Time.now - start_time, message)
    end

    class << self

      def logger
        @logger ||= Logger.new(STDERR)
      end

      def logger=(logger)
        @logger = logger
      end

    end
  end
end
