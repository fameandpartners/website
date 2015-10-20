require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  driver_options = {
      debug:             false,
      phantomjs_options: ['--load-images=no'],
  }
  Capybara::Poltergeist::Driver.new(app, driver_options)
end

Capybara.current_driver        = :poltergeist
Capybara.javascript_driver     = :poltergeist
Capybara.default_max_wait_time = 10
