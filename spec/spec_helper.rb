ENV['RAILS_ENV'] ||= 'test'

# Tire tries to connect Elasticsearch on boot, and webmock blocks it.
# Source: https://github.com/karmi/retire/issues/136
require 'webmock/rspec'
WebMock.allow_net_connect!(net_http_connect_on_start: false)

require File.expand_path('../../config/environment', __FILE__)

require 'rspec/rails'
require 'turnip/capybara'
require 'capybara/rails'
require 'shoulda/matchers'
require 'ffaker'
require 'chosen-rails/rspec'
require 'constants/order_bot'

# Rails.application.railties.all { |r| r.eager_load! }

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
Dir[Rails.root.join("engines/admin_ui/spec/support/**/*.rb")].each {|f| require f}
Dir[Rails.root.join("engines/wedding-atelier/spec/factories/**/*.rb")].each {|f| require f}
Dir[Rails.root.join("engines/wedding-atelier/spec/support/**/*.rb")].each {|f| require f}
Dir[Rails.root.join("engines/manual_order/spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.alias_it_should_behave_like_to :it_will, 'it will'

  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  # config.mock_with :mocha

  config.infer_base_class_for_anonymous_controllers = false

  # Use DatabaseCleaner for transactions
  config.use_transactional_fixtures = false
  # Max height max width
  config.before(:each) do
    stub_request(:get, OrderBot::MEASURE_TYPE_URI).
      to_return(status: 200, body: OrderBot::MEASURE_TYPE_RESPONSE, headers: {})


    stub_request(:post, OrderBot::PRODUCT_URI).
      with(body: "[\"junk\"]").
      to_return(status: 200, body: OrderBot::PRODUCT_RESPONSE, headers: {})

     stub_request(:post, OrderBot::PRODUCT_URI).
      with(body: "[\"fail\"]").
      to_return(status: 200, body: OrderBot::PRODUCT_FAILURE_RESPONSE, headers: {})

  end

   config.before(:each, js: true) do
   Capybara.page.driver.browser.resize(2000,1400)
  end
end

# TODO: remove this RSpec monkey patching when updating to latest RSpec. See https://github.com/fameandpartners/website/issues/1912
RSpec::Rails::ViewRendering::EmptyTemplatePathSetDecorator.class_eval do
  def initialize(original_path_set)
    super()
    @original_path_set = original_path_set
  end

  def find_all_anywhere(*args)
    find_all(args)
  end
end
