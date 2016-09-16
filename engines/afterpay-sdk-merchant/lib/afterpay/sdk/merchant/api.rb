require 'afterpay-sdk-core'

module Afterpay
  module SDK
    module Merchant
      class API < Core::API::Merchant
        include Services
        include Urls

        MERCHANT_HTTP_HEADER = { 'X-AFTERPAY-REQUEST-SOURCE' => "merchant-ruby-sdk-#{VERSION}" }.freeze

        def initialize(environment = nil, options = {})
          super('', environment, options)
        end

        def default_http_header
          super.merge(MERCHANT_HTTP_HEADER)
        end

    end
  end
end
