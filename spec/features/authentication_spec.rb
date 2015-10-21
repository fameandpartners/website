require 'spec_helper'

describe 'authentication process', :type => :feature do
  describe 'login' do
    context 'with valid credentials' do
      let!(:user_password) { 'my-secure-password-#2' }
      let!(:user_email)    { 'something@example.com' }
      let!(:user)          { create(:spree_user, skip_welcome_email: true, email: user_email, password: user_password, password_confirmation: user_password) }

      it 'should authenticate' do
        visit '/login'

        within('#password-credentials') do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
        end

        expect(page).to_not have_content 'Invalid email or password.'
        expect(page.status_code).to eq(200)
      end
    end

    context 'with invalid credentials' do
      it 'should authenticate' do
        visit '/login'

        within('#password-credentials') do
          fill_in 'Email', with: 'anything'
          fill_in 'Password', with: 'nothing'
        end

        click_button('Login')

        expect(page).to have_content 'Invalid email or password.'
        expect(page.status_code).to eq(200)
      end
    end
  end
end
