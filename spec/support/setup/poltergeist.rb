require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  poltergeist_options = {
    debug:             false,
    js_errors:         true,
    phantomjs_options: ['--ssl-protocol=TLSv1.2'],
    timeout:           ENV.fetch('CAPYBARA_DEFAULT_MAX_WAIT_TIME', '180').to_i,
    window_size:       [1366, 768],
  }

  Capybara::Poltergeist::Driver.new(app, poltergeist_options)
end

Capybara.javascript_driver = :poltergeist
