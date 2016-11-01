require 'spec_helper'

describe Products::DetailsController, :type => :controller do
  before(:each) { allow(Products::CollectionFilter).to receive(:read) }

  describe 'GET show' do
    it 'responds with success' do
      create(:dress, id: 202, name: 'Alexa')

      get :show, product_slug: 'alexa-202'
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end

    context 'does not find any product' do
      it 'responds with a 404' do
        get :show, product_slug: 'nothing-will-be-found'
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'product is unavailable' do
      it 'responds with a 404' do
        create(:dress, id: 101, name: 'Tate', available_on: 2.days.from_now)

        get :show, product_slug: 'tate-101'
        expect(response).to have_http_status(:not_found)
        expect(response).to render_template(:show)
      end
    end

    describe 'tracking activities' do
      it 'records the visit for the product' do
        product_id = 202
        scope = Activity.where(owner_type: 'Spree::Product', owner_id: product_id)

        expect(scope.count).to eq 0

        create(:dress, id: product_id, name: 'Alexa')
        get :show, product_slug: 'alexa-202'

        expect(scope.count).to eq 1
      end
    end
  end
end
