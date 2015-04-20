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

  describe 'private methods' do
    let(:collection_details) { double('Collection Details', meta_title: 'My Title', seo_description: 'My Description') }
    let(:collection_double) { double('Collection', details: collection_details) }

    describe '#set_collection_seo_meta_data' do
      before(:each) do
        controller.instance_variable_set(:@collection, collection_double)
      end

      describe 'sets the @title, @description, @status and @canonical of a collection' do
        it 'has the @title and @description' do
          controller.send(:set_collection_seo_meta_data)

          expect(controller.instance_variable_get(:@title)).to eq('My Title | - Fame & Partners')
          expect(controller.instance_variable_get(:@description)).to eq('My Description')
        end

        context 'collection has options (a collection was found)' do
          it 'has @status :ok and @canonical is nil' do
            controller.instance_variable_set(:@collection_options, {})
            controller.send(:set_collection_seo_meta_data)

            expect(controller.instance_variable_get(:@status)).to eq(:ok)
            expect(controller.instance_variable_get(:@canonical)).to be_nil
          end
        end

        context 'collection has no options (a invalid collection was queried)' do
          it 'has @status :not_found and @canonical has the dresses_path' do
            controller.instance_variable_set(:@collection_options, nil)
            controller.send(:set_collection_seo_meta_data)

            expect(controller.instance_variable_get(:@status)).to eq(:not_found)
            expect(controller.instance_variable_get(:@canonical)).to eq(dresses_path)
          end
        end
      end
    end
  end
end