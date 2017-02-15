require 'spec_helper'

describe 'registrations', type: :feature do

  describe 'registration' do
    before(:each) do
      enable_wedding_atelier_feature_flag
      ds = create(:option_type, name: 'dress-size')
      ds.option_values << create(:option_value, name: 'US0/AU2', presentation: 'US 0/AU 2')
    end

    context 'user already exists with complete profile' do
      let(:user_profile){ create(:wedding_atelier_user_profile) }
      let(:event){ create(:wedding_atelier_event) }
      let(:user){ create(:spree_user, wedding_atelier_signup_step: 'completed', user_profile: user_profile) }

      before { user.events << event }

      it 'signs the user in instead of sign up' do
        visit '/wedding-atelier/signup'
        within('.new_spree_user') do
          fill_in 'spree_user_email', with: user.email
          fill_in 'spree_user_password', with: user.password
        end
        click_button 'Next'
        expect(page.current_path).to eq "/wedding-atelier/events/#{event.id}/#{event.slug}"
      end
    end

    context 'user already exists with incomplete profile' do
      let(:user){ create(:spree_user) }

      it 'completes onboarding process' do
        visit '/wedding-atelier/signup'
        within('.new_spree_user') do
          fill_in 'spree_user_email', with: user.email
          fill_in 'spree_user_password', with: user.password
        end
        click_button 'Next'
        expect(page.current_path).to eq "/wedding-atelier/signup/size"
        click_button 'next'
        expect(page).to have_content "Dress size can't be blank"
        select("4'10\"/147cm", from: 'spree_user_user_profile_attributes_height')
        find(:css, '.sizing-row:first-child .dress-size:first-child label').click
        click_button 'next'
        expect(page.current_path).to eq "/wedding-atelier/signup/details"
        click_button 'next'
        expect(page).to have_content "can't be blank"
        fill_in 'weddding_name', with: 'Awesome wedding'
        select('Bride', from: 'wedding_role')
        fill_in 'wedding_bridesmaids', with: 2
        fill_in 'wedding_date', with: 1.month.from_now.strftime('%m/%d/%Y')
        click_button 'next'
        expect(page.current_path).to eq "/wedding-atelier/signup/invite"
        click_link 'do this later'
        event = user.events.last
        expect(page.current_path).to eq "/wedding-atelier/events/#{event.id}/#{event.slug}"
      end
    end

    context 'new user' do
      it 'completes onboarding process' do
        visit '/wedding-atelier/signup'
        within('.new_spree_user') do
          fill_in 'spree_user_first_name', with: 'foo'
          fill_in 'spree_user_last_name', with: 'bar'
          fill_in 'spree_user_email', with: 'foo@bar.com'
          fill_in 'spree_user_password', with: 'password'
        end
        click_button 'Next'
        expect(page.current_path).to eq "/wedding-atelier/signup/size"
        click_button 'next'
        expect(page).to have_content "Dress size can't be blank"
        select("4'10\"/147cm", from: 'spree_user_user_profile_attributes_height')
        find(:css, '.sizing-row:first-child .dress-size:first-child label').click
        click_button 'next'
        expect(page.current_path).to eq "/wedding-atelier/signup/details"
        click_button 'next'
        expect(page).to have_content "can't be blank"
        fill_in 'weddding_name', with: 'Awesome wedding'
        select('Bride', from: 'wedding_role')
        fill_in 'wedding_bridesmaids', with: 2
        fill_in 'wedding_date', with: 1.month.from_now.strftime('%m/%d/%Y')
        click_button 'next'
        expect(page.current_path).to eq "/wedding-atelier/signup/invite"
        click_link 'do this later'
        event = Spree::User.where(email: 'foo@bar.com').first.events.last
        expect(page.current_path).to eq "/wedding-atelier/events/#{event.id}/#{event.slug}"
      end
    end
  end
end
