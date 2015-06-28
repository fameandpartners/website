require 'rails_helper'

RSpec.describe MysteriousRouteController, type: :controller do
  describe "GET #undefined" do
    it "returns not found" do
      get :undefined
      expect(response).to have_http_status(:not_found)
    end
  end
end

RSpec.describe MysteriousRouteController, type: :routing do

  let(:controller) { { controller: 'mysterious_route', action: 'undefined'} }

  it "/au/undefined" do
    expect(get: "/undefined").to route_to(controller)
  end
  it "/au/undefined" do
    expect(get: "/au/undefined").to route_to(controller)
  end
end

RSpec.describe 'Product "undefined" Redirection', type: :request do

  before do
    seed_site_zone
    Revolution::Page.create!(:path => '/dresses/*', :template_path => '/products/collections/show.html.slim').publish!
  end

  context 'undefined urls on product collections' do
    it_will :redirect,
            "/dresses/plus-size/undefined",
            "/undefined"
  end
end
