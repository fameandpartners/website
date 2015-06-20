ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../test/dummy/config/environment", __FILE__)

require 'rspec/rails'
require 'capybara/rails'
require 'shoulda/matchers'
require 'database_cleaner'

RSpec.configure do |config|
  config.include(FactoryGirl::Syntax::Methods)
  #config.include(Rails.application.routes.url_helpers)

  config.infer_base_class_for_anonymous_controllers = false

  # Use DatabaseCleaner instead of ActiveRecord transactional
  config.use_transactional_fixtures = false

  config.before(:suite) do    
    DatabaseCleaner.strategy = :transaction
  end
end
