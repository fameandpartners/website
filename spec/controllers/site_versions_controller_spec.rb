require 'spec_helper'

describe SiteVersionsController, type: :controller do
  describe 'GET close_country_warning' do
    it 'sets session close_country_warning session variable to true' do
      expect(session[:close_country_warning]).to be_nil
      get :close_country_warning
      expect(session[:close_country_warning]).to be_truthy
    end
  end
end
