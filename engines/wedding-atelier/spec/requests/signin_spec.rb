require 'spec_helper'

describe 'Login Process (Sign In)', type: :request do
  before(:each) { enable_wedding_atelier_feature_flag }

  let(:user) { FactoryGirl.create(:spree_user) }

  context 'when an user is logged in' do
    before(:each) { wedding_sign_in(user) }

    describe 'sign in process' do
      it 'redirects the user to her event' do
        get '/wedding-atelier/sign_in'

        expect(response).to redirect_to(wedding_atelier.events_path)
      end
    end
  end

  context 'when an user is logged out' do
    it 'logs in redirecting the user to her events path' do
      post '/wedding-atelier/sign_in', spree_user: { email: user.email, password: user.password }

      expect(response).to redirect_to(wedding_atelier.events_path)
    end
  end
end
