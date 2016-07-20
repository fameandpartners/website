module Acceptance
  module Navigation
    module ExpectationsSteps
      step 'I should see :content' do |content|
        expect(page).to have_content(content)
      end

      step 'I should not see :content' do |content|
        expect(page).not_to have_content(content)
      end

      step 'I should see an active :link link' do |link|
        # TODO: "disabled" is not a valid "a" tag attribute! This should be moved to a CSS class
        a_tag = find_link(link)
        expect(a_tag['disabled']).not_to eq('true')
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
