require 'spec_helper'

describe 'auth process', type: :feature, js: true do
  let!(:user) { create(:spree_user, skip_welcome_email: true) }

  describe 'login' do
    before(:each) { enable_wedding_atelier_feature_flag }

    context 'with valid credentials' do
      context 'when profile is completed' do
        let!(:completed_user) { create(:spree_user, wedding_atelier_signup_step: 'completed', skip_welcome_email: true) }
        it 'authenticates to wedding atelier' do
          sign_in_with(completed_user.email, completed_user.password)
          expect(page).not_to have_content 'Invalid email or password.'
          expect(page.current_path).to eq '/wedding-atelier/events'
        end
      end

      context 'when profile is not completed' do
        it 'authenticates to wedding atelier' do
          sign_in_with(user.email, user.password)
          expect(page).not_to have_content 'Invalid email or password.'
          expect(page.current_path).to eq '/wedding-atelier/signup/size'
        end
      end
    end

    context 'with invalid credentials' do
      it 'renders error' do
        sign_in_with(user.email, 'invalid_password')
        expect(page).to have_content 'Invalid email or password.'
      end
    end
  end
end
