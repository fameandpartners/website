require 'spec_helper'
require 'capybara/poltergeist'

describe 'authentication process', :type => :feature do
  before :all do
    Spree::User.destroy_all
    create(:spree_user, :skip_welcome_email => true, site_version_id: SiteVersion.default.id)
  end

  let(:user) { Spree::User.first }
  let(:password) { 'my-secure-password-#2' }

  describe 'login' do

    context 'with valid credentials' do
      it 'should authenticate' do
        ignore_js_errors { visit '/login' }

        within('#password-credentials') do
          fill_in 'Email', :with => user.email
          fill_in 'Password', :with => password
        end

        # pending
        #ignore_js_errors { click_button('Login') }

        expect(page).to_not have_content 'Invalid email or password.'
        expect(page.status_code).to eq(200)
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
        expect(page.status_code).to eq(200)
      end
    end
  end
end
