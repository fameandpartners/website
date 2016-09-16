module Afterpay
  module SDK
    module Merchant
      module Urls

        REDIRECT_ENDPOINTS = {
          :live => 'https://api.secure-afterpay.com.au',
          :sandbox => 'https://api-sandbox.secure-afterpay.com.au/v1/' 
        }.freeze

        def redirect_url(params = {})
          "#{REDIRECT_ENDPOINTS[api_mode]}?#{encode_www_form(params)}"
        end

      end
    end
  end
end
