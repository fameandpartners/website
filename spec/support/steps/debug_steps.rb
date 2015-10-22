module Acceptance
  module DebugSteps
    step 'pry' do
      binding.pry
    end
  end
end

RSpec.configure { |c| c.include Acceptance::DebugSteps, type: :feature }
