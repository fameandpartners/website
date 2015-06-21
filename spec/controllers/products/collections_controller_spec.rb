require 'spec_helper'

describe Products::CollectionsController, :type => :controller do
  describe 'GET show' do
    let(:collection_details) { double('Collection Details', meta_title: 'My Title', seo_description: 'My Description') }
    let(:collection_double)  { double('Collection', details: collection_details) }
    let(:page)               { double(Revolution::Page, :get => false, :template_path => '/products/collections/show.html.slim', :locale= => true)}

    before(:each) do
      # Repositories and Resources should be tested elsewhere
      allow(Revolution::Page).to receive(:find_for).and_return(page)
      allow(Products::CollectionFilter).to receive(:read)
      allow(controller).to receive(:collection_resource).and_return(collection_double)
    end

    describe 'returns a 404 status' do
      before(:each) do
        allow(controller).to receive(:parse_permalink).and_return(nil)
      end

      it 'when querying a inexistent permalink' do
        get :show, permalink: 'nothing'
        expect(response).to render_template(file: 'public/404', layout: false)
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

  describe 'private methods' do
    describe '#set_collection_seo_meta_data' do
      describe 'sets @title and @description for a collection page' do
        context 'page is a lookbook' do
          let!(:lookbook_page)        { create(:revolution_page, variables: { lookbook: true }) }
          let!(:lookbook_translation) { create(:revolution_translation, page: lookbook_page, title: 'Lookbook Title', meta_description: 'Lookbook Meta Description', locale: 'en-US') }

          before(:each) { controller.instance_variable_set(:@page, lookbook_page) }

          it 'uses the page title and meta_description' do
            controller.send(:set_collection_seo_meta_data)

            expect(controller.instance_variable_get(:@title)).to include('Lookbook Title')
            expect(controller.instance_variable_get(:@description)).to eq('Lookbook Meta Description')
          end
        end

        context 'page is a collection' do
          let(:collection_details_double) { double('Collection Details', meta_title: 'Collection Title', seo_description: 'Collection Meta Description') }
          let(:collection_double) { double('Collection Double', details: collection_details_double) }

          before(:each) { controller.instance_variable_set(:@collection, collection_double) }

          it 'uses the collection details and meta_description' do
            controller.send(:set_collection_seo_meta_data)

            expect(controller.instance_variable_get(:@title)).to include('Collection Title')
            expect(controller.instance_variable_get(:@description)).to eq('Collection Meta Description')
          end
        end
      end
    end
  end
end
