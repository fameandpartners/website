require 'spec_helper'

module Products
  describe BaseController, type: :controller do
    before(:each) { allow(CollectionFilter).to receive(:read).and_return(:nothing) }
    
    describe 'GET search' do
      it 'correctly redirects if a search term redirect is in place' do
        expect(RedirectedSearchTerm).to receive(:find_by_term).with( 'prom' ).and_return( RedirectedSearchTerm.new( { term: 'prom', redirect_to: '/dresses' } ) )
        
        get :search, q: 'prom'
        response.should redirect_to '/dresses?q=prom'
      end

      it 'correctly redirects with a search term that has a space in it' do
        expect(RedirectedSearchTerm).to receive(:find_by_term).with( 'prom season' ).and_return( RedirectedSearchTerm.new( { term: 'prom season', redirect_to: '/dresses' } ) )
        
        get :search, q: 'prom season'
        response.should redirect_to '/dresses?q=prom+season'
        
      end

      it 'correctly redirects with a search term regardless of case' do
        expect(RedirectedSearchTerm).to receive(:find_by_term).with( 'prom' ).and_return( RedirectedSearchTerm.new( { term: 'prom', redirect_to: '/dresses' } ) )
        
        get :search, q: 'Prom'
        response.should redirect_to '/dresses?q=prom'
      end
      
      it 'sets its title based on the q param' do
        get :search, q: 'My Query'
        expect(assigns(:title)).to include('Search results for "My Query"')
      end

      it 'renders search template' do
        get :search
        expect(response).to render_template(:search)
      end

      it 'loads up collection filters' do
        expect(CollectionFilter).to receive(:read)
        get :search, q: 'My query'
      end
    end

    describe 'exception handling' do
      controller(described_class) do
        def inactive_product
          raise Errors::ProductInactive
        end

        def product_not_found
          raise Errors::ProductNotFound
        end
      end

      before(:each) do
        routes.draw do
          get 'inactive_product' => 'products/base#inactive_product'
          get 'product_not_found' => 'products/base#product_not_found'
        end
      end

      it 'rescues errors with #search_for_product_not_found' do
        expect(controller).to receive(:search_for_product_not_found).twice

        get 'inactive_product'
        get 'product_not_found'
      end

      it 'renders search page with not found status, and the product name as a query' do
        get 'product_not_found', product_slug: 'evelyn-123'
        expect(response).to render_template(:search)
        expect(response).to have_http_status(:not_found)
        expect(controller.params[:q]).to eq('evelyn')
      end

      it 'loads up collection filters' do
        expect(CollectionFilter).to receive(:read)
        get 'product_not_found', product_slug: 'evelyn-123'
      end
    end
  end
end
