module Acceptance
  module Navigation
    module ProfileSteps
      step 'I visit my profile page' do
        visit '/profile'
      end

      step 'I should see my first name as :first_name' do |first_name|
        expect(page).to have_field('profile_first_name', with: first_name)
      end

      step 'I should see my last name as :last_name' do |last_name|
        expect(page).to have_field('profile_last_name', with: last_name)
      end
    end
  end
end

RSpec.configure do |config|
  config.include Acceptance::Navigation::ProfileSteps, type: :feature
end
