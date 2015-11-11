Capybara.configure do |config|
  config.match = :prefer_exact
end

Capybara.default_max_wait_time = ENV.fetch('CAPYBARA_DEFAULT_MAX_WAIT_TIME', '180').to_i
