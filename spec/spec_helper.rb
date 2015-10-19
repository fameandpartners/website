ENV['RAILS_ENV'] ||= 'test'

# Tire tries to connect Elasticsearch on boot, and webmock blocks it.
# Source: https://github.com/karmi/retire/issues/136
require 'webmock/rspec'
WebMock.allow_net_connect!(net_http_connect_on_start: true)

require File.expand_path('../../config/environment', __FILE__)

require 'rspec/rails'
require 'capybara/rails'
require 'shoulda/matchers'
require 'database_cleaner'
require 'ffaker'
require 'rack_session_access/capybara'

# Rails.application.railties.all { |r| r.eager_load! }

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

def seed_site_zone
  country = Spree::Country.where({
                                     iso_name:        'UNITED STATES',
                                     iso:             'US',
                                     iso3:            'USA',
                                     name:            'United States',
                                     numcode:         840,
                                     states_required: true
                                 }).first_or_create
  zone    = Spree::Zone.where(name: 'us').first_or_create
  zone.members.create(zoneable_id: country.id, zoneable_type: country.class.to_s)

  SiteVersion.create({
                         permalink: 'us',
                         name:      'us',
                         zone_id:   zone.id,
                         currency:  'USD',
                         locale:    'en-US',
                         default:   true
                     })
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

  config.before(:suite) { seed_site_zone }

  Capybara.register_driver :poltergeist do |app|
    driver_options = {
      js_errors: true,
      timeout: 10,
      debug: false,
      extensions: [ 'features/support/page_load.js' ],
      phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes'],
      phantomjs_logger: Logger.new('/dev/null')
    }
    if true # local machine
      driver_options.merge!({
        logger: Kernel,
        js_errors: true,
        inspector: true,
        debug: true
      })
    end
    Capybara::Poltergeist::Driver.new(app, driver_options)
  end

  Capybara.current_driver = :poltergeist
  Capybara.javascript_driver = :poltergeist
  Capybara.default_wait_time = 10
end

Rails.application.config do
  config.middleware.use RackSessionAccess::Middleware
end
