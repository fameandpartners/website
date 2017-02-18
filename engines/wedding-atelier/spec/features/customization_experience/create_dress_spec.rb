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
      find(:css, '.add-dress-box .add').click
      expect(page).to have_content 'Customize and make it yours.'
    end
  end
end
