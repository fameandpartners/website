require 'spec_helper'

describe WeddingAtelier::LikesController, type: :controller do
  routes { WeddingAtelier::Engine.routes }
  let(:event) { create(:wedding_atelier_event) }
  let(:dress) { create(:wedding_atelier_event_dress, event: event) }
  let(:user) { create(:spree_user, first_name: 'foo', last_name: 'bar') }
  before do
    wedding_sign_in user
  end

  describe 'POST#create' do
    context 'new like' do
      it 'likes the dress' do
        post :create, { event_id: event.slug, dress_id: dress.id }
        json = JSON.parse(response.body)
        expect(json["like"]["event_dress_id"]).to eq dress.id
        expect(json["like"]["user_id"]).to eq user.id
      end
    end

    context 'already liked by user' do
      it 'fails liking the dress' do
        WeddingAtelier::Like.create(event_dress_id: dress.id, user_id: user.id)
        post :create, { event_id: event.slug, dress_id: dress.id }
        json = JSON.parse(response.body)
        expect(json["errors"][0]).to eq "Event dress has already been taken"
      end
    end
  end

  describe 'DELETE#destroy' do
    it 'dislikes the dress' do
      WeddingAtelier::Like.create(event_dress_id: dress.id, user_id: user.id)
      delete :destroy, { event_id: event.slug, dress_id: dress.id }
      json = JSON.parse(response.body)
      expect(json["like"]["event_dress_id"]).to eq dress.id
      expect(json["like"]["user_id"]).to eq user.id
    end
  end
end
