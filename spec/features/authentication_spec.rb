require 'spec_helper'

describe 'authentication process', type: :feature do
  let!(:site_version) { create(:site_version, :us, :default) }
  let!(:user) { create(:spree_user, skip_welcome_email: true) }

  describe 'login' do
    context 'with valid credentials' do
      it 'should authenticate' do
        configatron.temp do
          configatron.node_pdp_url = 'https://content-dev2.fameandgroups.com'
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

    context 'with invalid credentials' do
      it 'should authenticate' do
        configatron.temp do
          configatron.node_pdp_url = 'https://content-dev2.fameandgroups.com'
        
          visit '/login'

          within('#password-credentials') do
            fill_in 'Email', with: user.email
            fill_in 'Password', with: 'nothing-to-see-here'
          end

          click_button 'Login'
          expect(page).to have_text('Invalid email or password')
        end
      end
    end
  end
end
