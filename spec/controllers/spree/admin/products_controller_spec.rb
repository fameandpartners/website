require 'rails_helper'

describe Spree::Admin::ProductsController, type: :controller do
  let(:user) { build_stubbed(:spree_user) }

  before(:each) do
    allow(controller).to receive_messages(
      try_spree_current_user: user,
      authorize!: true
    )
  end

  describe 'GET /admin/search/jackets' do
    let!(:jackets_taxon)  { create(:taxon, :jackets) }
    let!(:denim_jacket)   { create(:jacket, name: 'Denim Jacket', id: 101, taxons: [jackets_taxon]) }
    let!(:leather_jacket) { create(:jacket, id: 102, taxons: [jackets_taxon]) }
    let!(:dress)          { create(:dress, id: 103) }

    context "given 'ids' param" do
      it 'returns jackets with the ids' do
        get :search_jackets, { ids: '101,102,103' }
        expect(assigns[:products]).to match([denim_jacket, leather_jacket])
      end
    end

    context "given 'q' param" do
      it 'returns jackets with queried name' do
        get :search_jackets, { q: 'Denim' }
        expect(assigns[:products]).to match([denim_jacket])
      end
    end
  end
end
