require 'spec_helper'
require_relative '../support/authorization_support'
require_relative '../support/helpers'

module AdminUi
  module Backend
    RSpec.describe FeaturesController, type: :controller do
      routes { AdminUi::Engine.routes }

      before(:each) do
        stub_admin_authorization!
        #Store the current state of the Feature Flags.  This will keep the users
        #dev environment intact as there is no "dev" Redis.
        @feat_store = save_feature_flags!
      end

      after(:each) do
        #Restore the state of the Feature Flags before the test was run
        restore_feature_flags!(@feat_store)
      end

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
        it { expect(controller.send(:feature_list)).to include :test_flag }
        it { expect(controller.send(:active_text, 'test_flag')).to eq 'Enabled' }
        it { expect(controller.send(:button_text, 'test_flag')).to eq 'Disable' }
        it { expect(controller.send(:button_path, 'test_flag')).to eq '/fame_admin/backend/features/disable?feature=test_flag' }
      end

    end
  end
end

