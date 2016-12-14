Capybara.configure do |config|
  config.always_include_port = true
  config.match               = :prefer_exact
end

Capybara.default_host          = ENV.fetch('CAPYBARA_DEFAULT_HOST', 'http://us.lvh.me')
Capybara.default_max_wait_time = ENV.fetch('CAPYBARA_DEFAULT_MAX_WAIT_TIME', '30').to_i

# Allow using Chrome
Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(
    app,
    browser:              :chrome,
    desired_capabilities: {
      'chromeOptions' => {
        'args' => %w{ window-size=1400,768 }
      }
    }
  )
end

# Selenium custom configurations
# On Mac, remember to point to `firefox-bin`. Example: "/Applications/Firefox.app/Contents/MacOS/firefox-bin"
Selenium::WebDriver::Firefox::Binary.path = ENV.fetch('CAPYBARA_SELENIUM_FIREFOX_BINARY_PATH', Selenium::WebDriver::Firefox::Binary.path)

RSpec.configure do |config|
  config.before(:each, selenium: true) do
    Capybara.current_session.current_window.resize_to(1400, 768)
  end
end
