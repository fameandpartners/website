require 'spec_helper'

describe 'Registration Process (Sign Up)', type: :request do
  before(:each) { enable_wedding_atelier_feature_flag }

  context 'when an user is logged in' do
    let(:user) { FactoryGirl.create(:spree_user) }

    before(:each) { wedding_sign_in(user) }

    describe 'sign up process' do
      context 'user has completed the process' do
        before(:each) do
          user.wedding_atelier_signup_step = 'completed'
          user.save!
        end

        it 'redirects the user to her event' do
          get '/wedding-atelier/signup'

          expect(response).to redirect_to(wedding_atelier.events_path)
        end
      end

      context 'user has not completed the process' do
        shared_examples 'redirects the user to her current signup step' do |signup_step|
          before(:each) do
            user.wedding_atelier_signup_step = signup_step
            user.save!
          end

          it 'redirects the user to her signup step' do
            get '/wedding-atelier/signup'

            expect(response).to redirect_to(action: signup_step)
          end
        end

        it_behaves_like 'redirects the user to her current signup step', 'size'
        it_behaves_like 'redirects the user to her current signup step', 'details'
      end
    end
  end
end
