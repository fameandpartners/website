require 'spec_helper'

describe 'authentication process', :type => :feature do

  let(:user) { create(:spree_user, :skip_welcome_email => true) }

  describe 'login' do

    context 'with valid credentials' do
      it 'should authenticate' do
        visit '/us/login'
        within('#password-credentials') do
          fill_in 'Email', :with => user.email
          fill_in 'Password', :with => user.password
        end
        click_button 'Log-in'        
        expect(page).to_not have_content 'Invalid email or password.'        
        expect(page).to have_content 'sign out'
        expect(page).to have_content user.first_name
      end
    end

    context 'with invalid credentials' do
      it 'should authenticate' do
        visit '/us/login'
        within('#password-credentials') do
          fill_in 'Email', :with => user.email
          fill_in 'Password', :with => 'adaljshdljhefih'
        end
        click_button 'Log-in'
        expect(page).to have_content 'Invalid email or password.'
      end
    end    

  end

end