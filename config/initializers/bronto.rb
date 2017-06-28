Bronto.setup do |config|
  config.api_token = ENV.fetch('BRONTO_API_TOKEN')
  config.wsdl_path = ENV.fetch('BRONTO_WSDL')
end
