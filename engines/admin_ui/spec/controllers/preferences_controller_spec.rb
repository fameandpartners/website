require 'rails_helper'
require_relative '../support/authorization_support'

RSpec.describe AdminUi::PreferencesController, type: :controller do
  routes { AdminUi::Engine.routes }
  before(:each) { stub_admin_authorization! }

  describe 'GET #index' do
    let(:site_versions)  { [:au, :us] }

    before(:each) do
      allow(SiteVersion).to receive(:all).and_return(site_versions)
    end

    it 'assigns all site versions' do
      get :index
      expect(assigns[:site_versions]).to eq(site_versions)
    end
  end

  describe 'PUT #update' do
    it 'updates existent spree configurations keys' do
      Spree::Config[:currency] = 'AUD'

      put :update, { currency: 'USD', something: 'nothing' }
      expect(Spree::Config[:currency]).to eq('USD')
    end

    it 'redirects back to preferences' do
      put :update
      expect(response).to redirect_to(preferences_path)
    end
  end
end
