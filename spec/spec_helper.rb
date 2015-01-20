ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'capybara/rails'
require 'shoulda/matchers'
require 'database_cleaner'


# Rails.application.railties.all { |r| r.eager_load! }

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

def create_test_data
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
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  # config.mock_with :mocha

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation, {:except => %w[site_versions spree_zones]}
    # DatabaseCleaner.strategy = :truncation, {:only => %w[spree_users]}
    # create_test_data
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end
end
