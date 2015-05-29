require 'spec_helper'

describe Products::BaseController, :type => :controller do
  describe 'GET search' do
    it 'sets its title based on the q param' do
      get :search, q: 'My Query'
      expect(assigns(:title)).to include('Search results for "My Query"')
    end

    it 'renders search template' do
      get :search
      expect(response).to render_template(:search)
    end
  end

  describe 'exception handling' do
    controller(Products::BaseController) do
      def inactive_product
        raise Errors::ProductInactive
      end

      def product_not_found
        raise Errors::ProductNotFound
      end
    end

    before(:each) do
      routes.draw do
        get 'inactive_product'  => 'products/base#inactive_product'
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
  end
end
