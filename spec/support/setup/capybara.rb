Capybara.configure do |config|
  config.match = :prefer_exact
end

Capybara.default_max_wait_time = 60
# Capybara.javascript_driver     = :poltergeist
Capybara.javascript_driver     = :selenium
