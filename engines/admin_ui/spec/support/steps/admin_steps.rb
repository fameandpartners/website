module Acceptance
  module AdminSteps
    step 'The example admin is signed in' do
      visit '/login'
      fill_in('Email', with: 'admin@example.com')
      fill_in('Password', with: '123456')
      click_button 'Login'
      visit '/fame_admin'
      expect(page).to have_text('Welcome to #new Admin')
    end
  end
end

RSpec.configure do |config|
  config.include Acceptance::AdminSteps, type: :feature
end
