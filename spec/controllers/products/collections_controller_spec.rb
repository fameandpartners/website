require 'spec_helper'

describe Products::CollectionsController, :type => :controller do
  describe 'GET show' do
    let(:collection_details) { double('Collection Details', meta_title: 'My Title', seo_description: 'My Description') }
    let(:collection_double) { double('Collection', details: collection_details) }

    before(:each) do
      # Repositories and Resources should be tested elsewhere
      allow(Products::CollectionFilter).to receive(:read)
      allow(controller).to receive(:collection_resource).and_return(collection_double)
    end

    describe 'returns a 404 status' do
      before(:each) do
        allow(controller).to receive(:parse_permalink).and_return(nil)
      end

      it 'when querying a inexistent permalink' do
        get :show, permalink: 'nothing'
        expect(response).to render_template(:show)
        expect(response).to have_http_status(:not_found)
      end
    end

    describe 'returns 200 a status code' do
      before(:each) do
        allow(controller).to receive(:parse_permalink).and_return({})
      end

      it 'when querying a valid collection resource' do
        get :show, permalink: 'brown'
        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end