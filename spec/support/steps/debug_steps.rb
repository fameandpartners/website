module DebugSteps
  step 'pry' do
    binding.pry
  end

  step 'open_page' do
    save_and_open_page
  end
end

RSpec.configure { |c| c.include DebugSteps }