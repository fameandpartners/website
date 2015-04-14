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

  it 'redirects old dresses/colour pages to main dresses' do
    get "dresses/color"
    expect(response).to redirect_to("/dresses")
  end

  it 'redirects old dresses/events page to all dresses' do
    get "dresses/event"
    expect(response).to redirect_to("/dresses")
  end

  it 'redirects old dresses/style page to all dresses' do
    get "dresses/style"
    expect(response).to redirect_to("/dresses")
  end

  it 'redirects old /celebrities page to all dresses' do
    get "/celebrities "
    expect(response).to redirect_to("/dresses")
  end

  it 'redirects old /plus-size page to all dresses' do
    get "/plus-size "
    expect(response).to redirect_to("/dresses")
  end

  it 'redirects old /how-it-works page to all /why-us' do
    get "/how-it-works"
    expect(response).to redirect_to("/why-us")
  end

  it 'redirects old fashionista2014 page to root' do
    get "/fashionista2014"
    expect(response).to redirect_to("/")
  end

  it 'redirects old /dani-stahl page to root' do
    get "/dani-stahl"
    expect(response).to redirect_to("/")
  end
end
