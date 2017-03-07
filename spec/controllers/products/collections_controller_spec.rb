require 'spec_helper'

describe Products::CollectionsController, type: :controller do
  describe 'GET show' do
    let(:collection_details) { double('Collection Details', meta_title: 'My Title', seo_description: 'My Description') }
    let(:collection_double)  { double('Collection', details: collection_details) }

    let(:page)               { Revolution::Page.create!(path: '/dresses', template_path: '/products/collections/show.html.slim') }
    let(:translation)        { page.translations.create!(locale: 'en-US', title: 'Test', meta_description: "Collection Meta Description") }


    before(:each) do
      # Repositories and Resources should be tested elsewhere
      allow(page).to receive(:collection=).with(collection_double)
      allow(Revolution::Page).to receive(:find_for).and_return(page)
      allow(Products::CollectionFilter).to receive(:read)
      allow(controller).to receive_messages(
                               collection_resource:   collection_double,
                               append_gtm_collection: true
                           )
    end

    describe 'before filters' do
      describe '#canonicalize_sales' do
        describe '`/dresses`, `/dresses/sale-all` and `/dresses?sale=number` have the same content as /dresses. Until they have different content, we should point canonical to `/dresses` page' do
          context 'params have sales' do
            it 'sets @canonical with dresses_path' do
              get :show, sale: 'all'
              expect(controller.instance_variable_get(:@canonical)).to eq('/dresses')
            end
          end

          context 'params does not have sales' do
            it '@canonical is kept nil' do
              get :show
              expect(controller.instance_variable_get(:@canonical)).to be_nil
            end
          end
        end
      end
    end

    describe 'returns a 404 status' do
      before(:each) do
        allow(controller).to receive(:parse_permalink).and_return(nil)
        allow(Rails.application.config).to receive(:consider_all_requests_local).and_return(false)
      end

      it 'when querying a inexistent permalink' do
        get :show, permalink: 'nothing'
        expect(response).to render_template(file: 'errors/404', layout: 'redesign/application')
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
    let(:page) { Revolution::Page.build(path: '/dresses', template_path: '/products/collections/show.html.slim') }


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
          let(:translation) { build(:revolution_translation, locale: 'en-US', title: 'Collection Title', meta_description: 'Collection Meta Description') }

          before(:each) { controller.instance_variable_set(:@page, translation) }

          it 'uses the collection details and meta_description' do
            controller.send(:set_collection_seo_meta_data)

            expect(controller.instance_variable_get(:@title)).to include('Collection Title')
            expect(controller.instance_variable_get(:@description)).to eq('Collection Meta Description')
          end
        end
      end
    end

    describe '#product_ids' do
      let(:page)  { Revolution::Page.new(path: '/dresses', template_path: '/products/collections/show.html.slim', variables: { pids: '123,456' }) }

      before(:each) { controller.instance_variable_set(:@page, page) }

      describe 'returns page or params product IDs' do
        context 'receives product ids in a hash' do
          before(:each) { controller.params = { pids: { '0' => '111', '1' => '222' } } }

          it { expect(controller.send(:product_ids)).to eq(%w(111 222)) }
        end

        context 'receives product ids in an array' do
          before(:each) { controller.params = { pids: %w(333 555) } }

          it { expect(controller.send(:product_ids)).to eq(%w(333 555)) }
        end

        context 'does not receive product ids' do
          it 'uses pages pids' do
            expect(controller.send(:product_ids)).to eq(%w(123 456))
          end
        end
      end
    end
  end
end
