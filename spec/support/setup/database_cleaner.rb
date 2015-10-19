RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:each, :js => true) do
    #DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.strategy = DatabaseCleaner::NullStrategy
  end
end
