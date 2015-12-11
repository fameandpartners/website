require 'rails_helper'
require_relative '../../app/controllers/admin_ui/features_controller'
require_relative '../support/authorization_support'

module AdminUi
  RSpec.describe AdminUi::FeaturesController, type: :controller do
    routes { AdminUi::Engine.routes }

    before(:each) do
      stub_admin_authorization!
      #Store the current state of the Feature Flags.  This will keep the users
      #dev environment intact as there is no "dev" Redis.
      @feat_store = []
      Features.features.each do |feature|
        @feat_store << { feature: feature, active: Features.active?(feature)}
      end
    end

    describe 'GET index' do
      it 'renders the index template' do
        get :index
        expect(response.status).to eq(200)
      end
    end

    describe 'GET enable' do
      before(:each) { get :enable, feature: 'test_flag' }
      it { expect(response).to redirect_to(features_path) }
      it { expect(flash[:notice]).to eq('Feature Flag test_flag was successfully Enabled.') }
      it { expect(Features.active?('test_flag')).to be_truthy }
    end

    describe 'GET disable' do
      before(:each) { get :disable, feature: 'test_flag' }
      it { expect(response).to redirect_to(features_path) }
      it { expect(flash[:notice]).to eq('Feature Flag test_flag was successfully Disabled.') }
      it { expect(Features.active?('test_flag')).to be_falsey }
    end

    describe 'GET new_ff' do
      before(:each) { get :new_ff }
      it { expect(assigns(:feature_flag)).to be_a_kind_of(FeatureFlag) }
      it { expect(assigns(:feature_flag).flag).to be_nil }
    end

    context 'POST create_ff' do
      describe 'unsuccessful flag creation' do
        it 'returns an error when the flag is empty' do
          post :create_ff, feature_flag: {flag: nil, enabled: 'true'}
          expect(assigns(:feature_flag).errors.get(:flag)[0]).to eq "can't be blank"
        end
        it 'returns an error when the flag already exists' do
          post :create_ff, feature_flag: {flag: 'enhanced_moodboards', enabled: 'true'}
          expect(assigns(:feature_flag).errors.get(:flag)[0]).to eq " already used."
        end
        it 'renders new_ff when there is a validation error' do
          post :create_ff, feature_flag: {flag: 'enhanced_moodboards', enabled: 'true'}
          expect(response).to render_template(:new_ff)
        end
      end
      describe 'successful flag creation' do
        before(:each) {post :create_ff, feature_flag: {flag: 'test_flag', enabled: 'true'} }
        it { expect(assigns(:feature_flag).flag).to eq 'test_flag' }
        it { expect(assigns(:feature_flag).enabled).to eq 'true' }
        it { expect(flash[:notice]).to eq('Feature Flag test_flag was successfully created as Enabled.') }
        it { expect(response).to redirect_to('http://us.lvh.me/fame_admin/features') }
      end
    end

    context 'helper_methods' do
      before(:each) { post :create_ff, feature_flag: {flag: 'test_flag', enabled: 'true'} }
      it { expect(controller.send(:feature_list)).to include :test_flag }
      it { expect(controller.send(:active?, 'test_flag')).to eq 'Enabled' }
      it { expect(controller.send(:button_text, 'test_flag')).to eq 'Disable' }
      it { expect(controller.send(:button_path, 'test_flag')).to eq '/fame_admin/features/disable?feature=test_flag' }
    end

    after(:each) do
      #Restore the state of the Feature Flags before the test was run
      Features.clear!
      @feat_store.each do |feature|
        feature[:active] == 'true' ? Features.activate(feature[:feature]) : Features.deactivate(feature[:feature])
      end
    end

  end
end
