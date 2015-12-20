require 'spec_helper'

module AdminUi
  module Backend
    RSpec.describe FeaturesController, type: :controller do
      routes { AdminUi::Engine.routes }

      before(:each) {
        stub_admin_authorization!
        stub_const("Features::DEFINED_FEATURES", %i(checkout_fb_login
                          content_revolution
                          delivery_date_messaging
                          enhanced_moodboards
                          fameweddings
                          maintenance
                          send_promotion_email_reminder
                          shipping_message
                          test_analytics
                          express_making
                          gift
                          google_tag_manager
                          marketing_modals
                          masterpass
                          moodboard
                          style_quiz
                          redirect_to_com_au_domain
                          getitquick_unavailable
                          sales
                          test_flag))
      }

      describe 'GET index' do
        it 'renders the index template' do
          get :index
          expect(response.status).to eq(200)
        end
      end

      describe 'GET enable' do
        before(:each) { get :enable, feature: 'test_flag' }
        it { expect(response).to redirect_to(backend_features_path) }
        it { expect(flash[:notice]).to eq('Feature Flag test_flag was successfully Enabled.') }
        it { expect(Features.active?('test_flag')).to be_truthy }
      end

      describe 'GET disable' do
        before(:each) { get :disable, feature: 'test_flag' }
        it { expect(response).to redirect_to(backend_features_path) }
        it { expect(flash[:notice]).to eq('Feature Flag test_flag was successfully Disabled.') }
        it { expect(Features.active?('test_flag')).to be_falsey }
      end

      context 'helper_methods' do
        before(:each) { Features.activate('test_flag') }
        it { expect(subject.feature_list).to include :test_flag }
        it { expect(subject.active_text('test_flag')).to eq 'Enabled' }
        it { expect(subject.button_text('test_flag')).to eq 'Disable' }
        it { expect(subject.button_path('test_flag')).to eq '/fame_admin/backend/features/disable?feature=test_flag' }
      end

    end
  end
end

