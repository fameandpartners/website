require 'spec_helper'

describe Products::DetailsController, :type => :controller do
  describe 'GET show' do
    it 'responds with success' do
      create(:dress, id: 202, name: 'Alexa', permalink: 'alexa-202')

      get :show, product_slug: 'alexa-202'
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end

    context 'it does not find any product' do
      it 'responds with a 404' do
        get :show, product_slug: 'nothing-will-be-found'
        expect(response).to have_http_status(:not_found)
      end
    end


    describe 'tracking activities' do
      it 'records the visit for the product' do
        product_id = 202
        scope = Activity.where(owner_type: 'Spree::Product', owner_id: product_id)

        expect(scope.count).to eq 0

        create(:dress, id: product_id, name: 'Alexa', permalink: 'alexa-202')
        get :show, product_slug: 'alexa-202'

        expect(scope.count).to eq 1
      end
    end
  end
end
