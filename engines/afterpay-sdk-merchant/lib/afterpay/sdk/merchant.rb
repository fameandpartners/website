module Afterpay
  module SDK
    module Merchant

      autoload :VERSION,   'afterpay/sdk/merchant/version'
      autoload :Services,  'afterpay/sdk/merchant/services'
      autoload :DataType,  'afterpay/sdk/merchant/data_type'
      autoload :Urls,      'afterpay/sdk/merchant/urls'
      autoload :API,       'afterpay/sdk/merchant/api'

      def self.new(*args)
        API.new(*args)
      end

    end
  end
end
