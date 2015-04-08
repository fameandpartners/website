RSpec.configure do |config|
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



  # config.use_transactional_fixtures = false
  #
  # config.before :suite do
  #   DatabaseCleaner.clean_with :truncation
  # end
  #
  # config.before do
  #   DatabaseCleaner.strategy = :transaction
  # end
  #
  # config.before(:each, javascript: true) do
  #   DatabaseCleaner.strategy = :deletion
  # end
  #
  # config.before do
  #   DatabaseCleaner.start
  # end
  #
  # config.after do
  #   DatabaseCleaner.clean
  # end
  #
  # config.after(:each, type: feature) do
  #   Capybara.reset_sessions!
  # end
end
