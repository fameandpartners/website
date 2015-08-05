require 'rails_helper'

RSpec.describe AdminUi::PreferencesController, type: :controller do
  describe 'PUT #update' do
    it 'updates existent spree configurations keys' do
      get :update
      expect(response).to have_http_status(:success)
    end
  end
end
