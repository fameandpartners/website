require 'spec_helper'

describe 'Product Routes', type: :routing do

  let(:product_show_routing) {
    {"controller"   => "products/details",
     "action"       => "show",
     "site_version" => "au",
     "product_slug" => "first-in-line-467",
     "color_name"   => "white"}
  }

  it { expect(:get => "/au/dresses/dress-first-in-line-467/white").to route_to(product_show_routing) }
end

describe 'Product Redirection', type: :request do
  it 'redirects old customisation pages to main product page' do
    get "/au/dresses/custom-first-in-line-467/white"
    expect(response).to redirect_to("/au/dresses/dress-first-in-line-467/white")
  end

  it 'redirects old accessory pages to main product page' do
    get "/au/dresses/styleit-first-in-line-467/white"
    expect(response).to redirect_to("/au/dresses/dress-first-in-line-467/white")
  end
end
