require 'spec_helper'
describe WeddingAtelier::SizingController, type: :controller do
  routes { WeddingAtelier::Engine.routes }
  let(:user) { create(:spree_user, first_name: 'foo', last_name: 'bar') }
  before do
    wedding_sign_in user
  end

  describe '#index' do
    before do
      ot = create(:option_type, name: 'dress-size')
      ot.option_values << create(:option_value, name: 'US0/AU4')
    end

    it 'gets a list of sizes and heiths' do
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response["sizing"]["sizes"][0]["name"]).to eq 'US0/AU4'
      expect(json_response["sizing"]["heights"][0][0]).to eq 'petite'
      expect(json_response["sizing"]["heights"][0][1][0]).to eq "4'10\"/147cm"
    end
  end
end
