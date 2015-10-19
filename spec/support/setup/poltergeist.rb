Capybara.register_driver :poltergeist do |app|
  driver_options = {
      js_errors:         true,
      timeout:           10,
      debug:             true,
      extensions:        ['features/support/page_load.js'],
      phantomjs_options: %w(--load-images=no --ignore-ssl-errors=yes),
      phantomjs_logger:  Logger.new('/dev/null'),
      logger:            Kernel,
      inspector:         true
  }
  Capybara::Poltergeist::Driver.new(app, driver_options)
end

Capybara.current_driver        = :poltergeist
Capybara.javascript_driver     = :poltergeist
Capybara.default_max_wait_time = 10
