module Afterpay
  module SDK
    module Merchant

      autoload :VERSION,   'afterpay/sdk/merchant/version'
      autoload :Services,  'afterpay/sdk/merchant/services'
      autoload :API,       'afterpay/sdk/merchant/api'

      def self.new(*args)
        API.new(*args)
      end

    end
  end
end
