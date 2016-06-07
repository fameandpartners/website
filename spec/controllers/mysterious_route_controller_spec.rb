require 'rails_helper'

RSpec.describe Errors::MysteriousRouteController, type: :controller do
  describe "GET #undefined" do
    it "returns not found" do
      get :undefined
      expect(response).to have_http_status(:not_found)
    end
  end
end

RSpec.describe Errors::MysteriousRouteController, type: :routing do

  let(:controller) { { controller: 'errors/mysterious_route', action: 'undefined'} }

  it "/undefined" do
    expect(get: "/undefined").to route_to(controller)
  end

  it "/au/undefined" do
    expect(get: "/au/undefined").to route_to(controller)
  end

  it "/1000668'" do
    expect(get: '/1000668').to route_to(controller)
  end
end
