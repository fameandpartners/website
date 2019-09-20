require 'spec_helper'

module AdminUi
  module Backend
    RSpec.describe FeaturesController, type: :controller do
      render_views
      routes { AdminUi::Engine.routes }
      puts("This is adminUi require 'spec_helper'" % AdminUi::Engine.routes)

      before(:each) do
        allow(controller).to receive(:current_admin_user).and_return(Spree::User.new)
        allow(controller).to receive(:authorize_admin).and_return(true)

        stub_const('Features::DEFINED_FEATURES', { test_flag: "TEST_FLAG_DOCUMENTATION" } )
      end

      describe 'GET index' do
        it 'shows documentation for features' do
          get :index

          expect(response.body).to include("TEST_FLAG_DOCUMENTATION")
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
    end
  end
end

