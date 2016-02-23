module Acceptance
  module Navigation
    module ExpectationsSteps
      step 'I should see :content' do |content|
        expect(page).to have_content(content)
      end

      step 'DOM is ready for JS interaction' do
        expect(page).to have_css('body.ready')
      end
    end
  end
end

RSpec.configure do |config|
  config.include Acceptance::Navigation::ExpectationsSteps, type: :feature
end
