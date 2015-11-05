module Acceptance
  module Navigation
    module ResolutionSteps
      DEVICES_RESOLUTIONS = {
          'small desktop' => [1024, 768]
      }

      step 'I use a :device resolution' do |device|
        width, height = DEVICES_RESOLUTIONS[device]

        window = Capybara.current_session.driver.browser.manage.window
        window.resize_to(width, height)
      end
    end
  end
end

RSpec.configure do |config|
  config.include Acceptance::Navigation::ResolutionSteps, type: :feature
end
