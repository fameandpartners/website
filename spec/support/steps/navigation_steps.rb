module Acceptance
  module NavigationSteps
    step 'I am on the homepage' do
      visit '/'
    end

    step 'I should see :content' do |content|
      expect(page).to have_content(content)
    end
  end
end

RSpec.configure { |c| c.include Acceptance::NavigationSteps, type: :feature }
