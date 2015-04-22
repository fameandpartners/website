ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'turnip/capybara'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'shoulda/matchers'
require 'database_cleaner'
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

  Capybara.register_driver :poltergeist do |app|
    #, js_errors: false

    phantomjs_extensions = Dir[Rails.root.join("spec/support/phantomjs_extensions/*.js")]
    driver               = Capybara::Poltergeist::Driver.new(app,
                                                             js_errors:  true,
                                                             debug:      true,
                                                             extensions: phantomjs_extensions
    )
    driver.resize(1280, 720)
    driver

  end

  Capybara.javascript_driver = :poltergeist

  Capybara.configure do |config|
    config.match = :prefer_exact
  end

  # Use DatabaseCleaner instead of ActiveRecord transactional
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    seed_site_zone
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
