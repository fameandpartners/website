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
    it 'adds homepage_title to @preferences_general' do
      get :edit
      expect(assigns(:preferences_general)).not_to be_nil
      expect(assigns[:preferences_general]).to include(:homepage_title)
    end
  end
end
