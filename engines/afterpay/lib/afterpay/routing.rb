module Afterpay
  AFTERPAY_URLS = {
    production:  'https://www.secure-afterpay.com.au',
    development: 'https://www-sandbox.secure-afterpay.com.au'
  }.stringify_keys

  AFTERPAY_MERCHANT_URL = AFTERPAY_URLS.fetch(Rails.env, AFTERPAY_URLS['development'])
end
