ENV['RAILS_ENV'] ||= 'test'

# Tire tries to connect Elasticsearch on boot, and webmock blocks it.
# Source: https://github.com/karmi/retire/issues/136
require 'webmock/rspec'
WebMock.allow_net_connect!(net_http_connect_on_start: true)

require File.expand_path('../../config/environment', __FILE__)

require 'rspec/rails'
require 'capybara/rails'
require 'shoulda/matchers'
require 'ffaker'

# Rails.application.railties.all { |r| r.eager_load! }

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

def seed_site_zone
  zone = Spree::Zone.create(name: 'us')
  args = {
    permalink: 'us',
    name: 'us',
    zone_id: zone.id,
    currency: 'USD',
    locale: 'en-US',
    default: true
  }
  SiteVersion.create(args)
end

RSpec.configure do |config|
  config.include(FactoryGirl::Syntax::Methods)
  config.include(Rails.application.routes.url_helpers)

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

  # Use DatabaseCleaner instead of ActiveRecord transactional
  config.use_transactional_fixtures = false

  config.before(:suite) do
    seed_site_zone
  end
end
