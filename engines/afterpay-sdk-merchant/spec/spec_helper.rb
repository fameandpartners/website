require 'bundler/setup'

require 'afterpay-sdk-merchant'
require 'vcr'

Bundler.require :default, :test
Afterpay::SDK::Core::Config.load('spec/config/afterpay.yml', 'test')

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.configure_rspec_metadata!
  c.hook_into :webmock
  c.ignore_localhost = true
  c.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |config|
  config.around(:each, no_vcr: true) do |example|
    WebMock.allow_net_connect!
    VCR.turned_off { example.run }
    WebMock.disable_net_connect!
  end
end
