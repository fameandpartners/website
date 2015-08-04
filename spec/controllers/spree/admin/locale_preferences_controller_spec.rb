require 'rails_helper'

RSpec.describe Spree::Admin::LocalePreferencesController, type: :controller do
  describe 'PUT #update' do
    it 'updates existent spree configurations keys' do
      skip

      get :update
      expect(response).to have_http_status(:success)
    end
  end
end
