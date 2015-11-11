module Acceptance
  module Navigation
    module ResolutionSteps
      DEVICES_RESOLUTIONS = {
          'small desktop' => [1024, 768]
      }

      step 'I use a :device resolution' do |device|
        pending 'needs poltergeist implementation'

        # TODO: This is valid for a selenium implementation. This won't work for poltergeist
        # width, height = DEVICES_RESOLUTIONS[device]
        #
        # window = page.driver.browser.manage.window
        # window.resize_to(width, height)
      end
    end
  end
end

RSpec.configure do |config|
  config.include Acceptance::Navigation::ResolutionSteps, type: :feature
end
