require 'spec_helper'

describe 'Change wedding details', type: :feature, js: true do
  let(:user_profile){ create(:wedding_atelier_user_profile) }
  let(:user) { create(:spree_user, wedding_atelier_signup_step: 'completed', user_profile: user_profile) }
  let(:event){ create(:wedding_atelier_event, owner: user, date: Date.tomorrow) }

  before(:each) do
    enable_wedding_atelier_feature_flag
    load_customization_fixtures
    user.add_role 'bride', event
    user.events << event
  end

  it 'updates wedding event' do
    sign_in_with(user.email, user.password)
    expect(page).to have_content('The Countdown: 1 days')
    click_link('Wedding details')
    find(:css, '.calendar-icon').click
    find(:css, '.datepicker-days tbody tr:last-child td:last-child').click
    click_button 'Save'
    expect(page).not_to have_content('The Countdown: 1 days')
  end

end
