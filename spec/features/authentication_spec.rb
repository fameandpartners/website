require 'spec_helper'

describe 'authentication process', :type => :feature do

  let(:user) { create(:spree_user, :skip_welcome_email => true) }

  describe 'login' do

    context 'with valid credentials' do
      it 'should authenticate', :chrome  do
        allow_any_instance_of(SiteVersion).to receive(:code).and_return("us")
        visit '/login'
        within('#password-credentials') do
          fill_in 'Email', :with => user.email
          fill_in 'Password', :with => user.password
        end
        click_button 'Login'
        expect(page).not_to have_content 'Invalid email or password.'
      end
    end

    context 'with invalid credentials' do
      it 'should authenticate', :chrome do
        allow_any_instance_of(SiteVersion).to receive(:code).and_return("us")
        visit '/login'
        within('#password-credentials') do
          fill_in 'Email', :with => user.email
          fill_in 'Password', :with => 'adaljshdljhefih'
        end
        click_button 'Login'
        within 'form' do
          expect(page).to have_text('INVALID EMAIL OR PASSWORD')
        end
      end
    end

  end

end
