require 'spec_helper'
require 'capybara/poltergeist'

describe 'authentication process', :type => :feature do
  before :each do
    Spree::User.destroy_all
  end

  let(:user) { create(:spree_user, :skip_welcome_email => true) }
  let(:password) { 'my-secure-password-#2' }

  describe 'login' do

    context 'with valid credentials' do
      it 'should authenticate' do
        ignore_js_errors { visit '/login' }

        user.password = user.password_confirmation = password
        user.save

        within('#password-credentials') do
          fill_in 'Email', :with => user.email
          fill_in 'Password', :with => password
        end
        ignore_js_errors { click_button('Login') }

        expect(page).to_not have_content 'Invalid email or password.'
      end
    end

    context 'with invalid credentials' do
      it 'should authenticate' do
        ignore_js_errors { visit '/login' }

        within('#password-credentials') do
          fill_in 'Email', :with => user.email
          fill_in 'Password', :with => 'adaljshdljhefih'
        end

        ignore_js_errors { click_button('Login') }

        expect(page).to have_content 'Invalid email or password.'
      end
    end
  end
end
