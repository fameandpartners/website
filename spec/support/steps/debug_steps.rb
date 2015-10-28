module Acceptance
  module DebugSteps
    step 'pry' do
      binding.pry
    end

    step 'open screenshot' do
      Capybara::Screenshot.screenshot_and_open_image
    end
  end
end

RSpec.configure { |c| c.include Acceptance::DebugSteps, type: :feature }
