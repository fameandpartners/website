module Acceptance
  module DebugSteps
    step 'pry' do
      require 'pry'
      binding.pry
    end

    step 'open screenshot' do
      Capybara::Screenshot.save_and_open_page
    end

    module Javascript
      step 'open screenshot' do
        Capybara::Screenshot.screenshot_and_open_image
      end
    end
  end
end

RSpec.configure { |c| c.include Acceptance::DebugSteps, type: :feature }
RSpec.configure { |c| c.include Acceptance::DebugSteps::Javascript, type: :feature, javascript: true }
