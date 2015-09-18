require 'spec_helper'

describe 'authentication process', :type => :feature do

  let(:user) { create(:spree_user, :skip_welcome_email => true) }

  describe 'login' do

    context 'with valid credentials' do
      it 'should authenticate' do
        begin
          visit '/login'
        rescue Capybara::Poltergeist::JavascriptError
        end

        within('#password-credentials') do
          fill_in 'Email', :with => user.email
          fill_in 'Password', :with => user.password
        end
        click_button 'Login'
        expect(page).to_not have_content 'Invalid email or password.'
      end
    end

    context 'with invalid credentials' do
      it 'should authenticate' do
        begin
          visit '/login'
        rescue Capybara::Poltergeist::JavascriptError
        end

        within('#password-credentials') do
          fill_in 'Email', :with => user.email
          fill_in 'Password', :with => 'adaljshdljhefih'
        end
        click_button 'Login'
        expect(page).to have_content 'Invalid email or password.'
      end
    end
  end
end
