module Acceptance
  module UserSteps
    step 'The example user is signed in' do
      visit '/login'
      fill_in('Email', with: 'spree@example.com')
      fill_in('Password', with: '123456')
      click_button 'Login'
    end
  end
end

RSpec.configure do |config|
  config.include Acceptance::UserSteps, type: :feature
end
