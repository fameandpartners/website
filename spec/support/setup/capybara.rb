Capybara.configure do |config|
  config.match = :prefer_exact
end

# Capybara.javascript_driver     = :poltergeist
Capybara.javascript_driver     = :selenium
Capybara.default_max_wait_time = ENV.fetch('CAPYBARA_DEFAULT_MAX_WAIT_TIME', '180').to_i
