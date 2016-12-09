require 'spec_helper'

describe WeddingAtelier::EventDressesController, type: :controller do
  routes { WeddingAtelier::Engine.routes }
  let(:event) { create(:wedding_atelier_event) }
  let(:product) { create(:spree_product) }
  let(:user) { create(:spree_user, first_name: 'foo', last_name: 'bar') }
  before do
    custom_sign_in user
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
    let(:dress) { create(:wedding_atelier_event_dress, user: user, product: product, event: event) }
    let(:color) { create(:option_value, name: 'updated color') }
    let(:other_product) { create(:spree_product) }
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
        json = JSON.parse(response.body)
        expect(json["event_dress"]["product"]["name"]).to eq other_product.name
        expect(json["event_dress"]["color"]["name"]).to eq color.name
      end
    end

    context 'with errors' do
      it 'it fails due to errors' do
        params = {
          event_id: event.slug,
          id: dress.id,
          event_dress: {
            product_id: 123123,
            color_id: color.id
          }
        }
        put :update, params
        json = JSON.parse(response.body)
        expect(json["errors"][0]).to eq "Product can't be blank"
      end
    end
  end

end
