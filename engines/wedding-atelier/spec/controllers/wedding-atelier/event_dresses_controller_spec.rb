require 'spec_helper'

describe WeddingAtelier::EventDressesController, type: :controller do
  routes { WeddingAtelier::Engine.routes }
  let(:event) { create(:wedding_atelier_event) }
  let(:product) { create(:spree_product) }
  let(:user) { create(:spree_user, first_name: 'foo', last_name: 'bar', wedding_atelier_signup_step: 'completed') }
  before do
    custom_sign_in user
    allow(controller).to receive(:current_spree_user).and_return(user)
    user.add_role('bride', event)
  end

  describe '#new' do
    it 'is successful' do
      get :new, { event_id: event.id }
      expect(response.status).to be 200
    end
  end

  describe '#edit' do
    let(:dress) { create(:wedding_atelier_event_dress, user: user, product: product, event: event) }
    it 'is successful' do
      get :edit, { event_id: event.id, id: dress.id }
      expect(response.status).to be 200
    end
  end

  describe '#create' do
    let(:fabric) { create(:customisation_value) }
    let(:color) { create(:option_value) }
    let(:length) { create(:customisation_value) }
    let(:size) { create(:option_value) }
    let(:height) { "5'6\"/167cm" }
    it 'creates an event dress with a base silhouette' do
      params = {
        event_id: event.id,
        event_dress: {
          product_id: product.id,
          fabric_id: fabric.id,
          color_id: color.id,
          length_id: length.id,
          size_id: size.id,
          height: height,
          user_id: user.id
        }
      }
      post :create, params
      dress_json = JSON.parse(response.body)["event_dress"]
      expect(dress_json["product"]["name"]).to eq product.name
    end
  end

  describe '#destroy' do
    let(:dress) { create(:wedding_atelier_event_dress, user: user, product: product, event: event) }
    it 'destroy the dress' do
      params = {
        event_id: event.id,
        id: dress.id
      }
      delete :destroy, params
      expect(response.status).to eq 200
      expect{dress.reload}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#update' do
    let(:dress) { create(:wedding_atelier_event_dress, user: user, product: product, event: event) }
    let(:color) { create(:option_value, name: 'updated color') }
    let(:other_product) { create(:spree_product) }
    let(:fabric) { create(:customisation_value) }
    let(:length) { create(:customisation_value) }
    let(:size) { create(:option_value) }
    let(:height) { "5'6\"/167cm" }
    context 'it assigns or replaces any customization' do
      it 'updates the base silhouette' do
        params = {
          event_id: event.id,
          id: dress.id,
          event_dress: {
            product_id: other_product.id,
            color_id: color.id,
            fabric_id: fabric.id,
            length_id: length.id,
            size_id: size.id,
            height: height,
            user_id: user.id
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
          event_id: event.id,
          id: dress.id,
          event_dress: {
            product_id: 123123,
            color_id: color.id
          }
        }
        put :update, params
        json = JSON.parse(response.body)
        expect(json["errors"][0]).to eq "Product can't be blank"
        expect(response.status).to be 422
      end
    end
  end

end
