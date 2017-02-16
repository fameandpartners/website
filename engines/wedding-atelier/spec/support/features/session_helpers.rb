module Features
  module SessionHelpers
    def sign_in_with(email ,password)
      visit '/wedding-atelier/sign_in'
      within('.email-signup') do
        fill_in 'spree_user_email', with: email
        fill_in 'spree_user_password', with: password
      end
      click_button 'Sign in'
    end
  end
end

RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
end
