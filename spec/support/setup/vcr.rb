require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.configure_rspec_metadata!
  c.hook_into :webmock
  c.ignore_localhost = true
  c.allow_http_connections_when_no_cassette = false

  # Afterpay
  ## Ignores its creation token call ()
  c.ignore_request do |request|
    request.headers['Use-Vcr'].nil? && \
      request.uri.include?('api-sandbox.secure-afterpay.com.au/v1/orders')
      request.uri.include?('orderbot')
  end

  # VCR Filters
  ## MailChimp
  c.filter_sensitive_data('<MAILCHIMP_API_KEY>') { ENV['MAILCHIMP_API_KEY'] }
  c.filter_sensitive_data('<MAILCHIMP_LIST_ID>') { ENV['MAILCHIMP_LIST_ID'] }
  c.filter_sensitive_data('<MAILCHIMP_STORE_ID>') { ENV['MAILCHIMP_STORE_ID'] }
  ## Bergen
  c.filter_sensitive_data('<BERGEN_ACCOUNT_ID>') { ENV['BERGEN_ACCOUNT_ID'] }
  c.filter_sensitive_data('<BERGEN_USERNAME>') { ENV['BERGEN_USERNAME'] }
  c.filter_sensitive_data('<BERGEN_PASSWORD>') { ENV['BERGEN_PASSWORD'] }
end

# Allow VCR to be turned off
RSpec.configure do |config|
  config.around(:each, no_vcr: true) do |example|
    WebMock.allow_net_connect!
    VCR.turned_off { example.run }
    WebMock.disable_net_connect!
  end

  config.around(:each, shorter_cassette_names: true) do |example|
    example.metadata[:vcr] = { cassette_name: example.full_description[0..100] }
    example.run
  end
end
