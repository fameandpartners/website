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
    # TODO: PR #322: 01/05/2015 alias_method broke production with a stack_level too deep. Check alternative
    xit 'adds homepage_title to @preferences_general' do
      get :edit
      expect(assigns(:preferences_general)).not_to be_nil
      expect(assigns[:preferences_general]).to include(:homepage_title)
    end
  end
end
