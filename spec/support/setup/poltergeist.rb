require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  poltergeist_options = {
      debug:       false,
      js_errors:   true,
      window_size: [1366, 768]
  }

  Capybara::Poltergeist::Driver.new(app, poltergeist_options)
end

Capybara.javascript_driver = :poltergeist
