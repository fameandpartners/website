require 'spec_helper'

describe 'Create new custom dress', type: :feature, js: true do
  let(:user_profile){ create(:wedding_atelier_user_profile) }
  let(:user) { create(:spree_user, wedding_atelier_signup_step: 'completed', user_profile: user_profile) }
  let(:event){ create(:wedding_atelier_event, owner: user) }

  before(:each) do
    enable_wedding_atelier_feature_flag
    load_customization_fixtures
    user.add_role 'bride', event
    user.events << event
  end

  context 'before leaving screen' do
    it 'saves the dress' do
      sign_in_with(user.email, user.password)
      dress_count = WeddingAtelier::EventDress.count
      find(:css, '.add-dress-box .add').click
      expect(page).to have_content 'Customize and make it yours.'
      find(:css, '.customizations #style').click
      find(:css, '#S1').click
      find(:css, '.customization-experience--desktop .save-dress-button').click
      expect(page).to have_content 'Your dress has been saved!'
      expect(WeddingAtelier::EventDress.count).to be > dress_count
    end
  end

  context 'trying to leave screen' do
    it 'saves the dress' do
      sign_in_with(user.email, user.password)
      dress_count = WeddingAtelier::EventDress.count
      find(:css, '.add-dress-box .add').click
      expect(page).to have_content 'Customize and make it yours.'
      find(:css, '.customizations #style').click
      find(:css, '#S1').click
      find(:css, '.js-customizations-container .selector-close').click
      find(:css, '.customization-experience-header-back-arrow').click
      expect(page).to have_content 'like to save this dress customization to the wedding moodboard?'
      find(:css, '.js-save-dress-before-leave-modal .save-dress-button').click
      sleep 5
      expect(WeddingAtelier::EventDress.count).to be > dress_count
    end
  end
end
