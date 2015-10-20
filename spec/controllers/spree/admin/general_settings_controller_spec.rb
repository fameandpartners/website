require 'rails_helper'

describe Spree::Admin::GeneralSettingsController, :type => :controller do
  let(:user) { build_stubbed(:spree_user) }

  before(:each) do
    allow(controller).to receive_messages(
      :try_spree_current_user => user,
      :authorize! => true
    )
  end

  describe 'GET /admin/general_settings/edit' do
    it 'removes default_seo_title and default_meta_keywords of @preferences_general array' do
      get :edit
      expect(assigns(:preferences_general)).not_to be_nil
      expect(assigns[:preferences_general]).not_to include(:default_seo_title)
      expect(assigns[:preferences_general]).not_to include(:default_meta_keywords)
    end
  end
end
