require 'spec_helper'

describe Products::SearchResultsController, :type => :controller do
  describe 'GET show' do
    it 'sets its title based on the q param' do
      get :show, q: 'My Query'
      expect(assigns(:title)).to eq('Search results for "My Query" | - Fame & Partners')
    end
  end
end