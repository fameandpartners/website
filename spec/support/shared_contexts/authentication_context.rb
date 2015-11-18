module Spec
  module Feature
    module Authentication
      def login_user(user = create(:spree_user, skip_welcome_email: true))
        visit '/login'
        within('#password-credentials') do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
        end
        click_button 'Login'
        expect(page).not_to have_content 'Invalid email or password.'
      end
    end
  end
end

RSpec.configure do |config|
  config.include Spec::Feature::Authentication, type: :feature
end
