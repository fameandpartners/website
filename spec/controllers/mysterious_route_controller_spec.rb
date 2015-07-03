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
