require 'afterpay-sdk-core'

module Afterpay
  module SDK
    module Merchant

      autoload :VERSION,   'afterpay-sdk/merchant/version'
      autoload :Services,  'afterpay-sdk/merchant/services'
      autoload :DataTypes, 'afterpay-sdk/merchant/data_types_with_bugfix'
      autoload :Urls,      'afterpay-sdk/merchant/urls'
      autoload :API,       'afterpay-sdk/merchant/api'

      def self.new(*args)
        API.new(*args)
      end

    end
  end
end
