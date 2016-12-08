require File.expand_path('../../../spec_helper.rb', __FILE__)

describe WeddingAtelier::EventDressesController, type: :controller do
  routes { WeddingAtelier::Engine.routes }
  let(:event) { create(:wedding_atelier_event) }
  let(:product) { create(:product) }

  before do
    sign_in create(:user)
  end

  describe '#new' do
    it 'is successful' do
      get :new, { event_id: event.slug }
      expect(response.status).to be 200
    end
  end

  describe '#create' do
    it 'creates an event dress with a base silhoutte' do
      params = {
        event_id: event.slug,
        event_dress: {
          product_id: product.id
        }
      }
      post :create, params
      dress_json = JSON.parse(response.body)["event_dress"]
      expect(dress_json["product"]["name"]).to eq product.name
    end
  end

  describe '#edit' do
  end

  describe '#update' do
    let(:dress) { create(:wedding_atelier_event_dress, product: product, event: event) }
    let(:color) { create(:option_value, name: 'updated color') }
    let(:other_product) { create(:product) }
    context 'it assigns or replaces any customization' do
      it 'updates the base silhouette' do
        params = {
          event_id: event.slug,
          id: dress.id,
          event_dress: {
            product_id: other_product.id,
            color_id: color.id
          }
        }
        put :update, params
        json_dress = JSON.parse(response.body)["event_dress"]
        expect(json_dress["product"]["id"]).to eq other_product.id
        expect(json_dress["color"]["id"]).to eq color.id
      end
    end
  end

end
