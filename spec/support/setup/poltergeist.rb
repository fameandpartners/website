require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  poltergeist_options = {
      debug:             false,
      js_errors:         false
  }

  Capybara::Poltergeist::Driver.new(app, poltergeist_options)
end
