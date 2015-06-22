require 'spec_helper'

describe 'Product Routes', type: :routing do

  let(:product_show_routing) {
    {"controller"   => "products/details",
     "action"       => "show",
     "site_version" => "au",
     "product_slug" => "first-in-line-467",
     "color"        => "white"}
  }

  it { expect(:get => "/au/dresses/dress-first-in-line-467?color=white").to route_to(product_show_routing) }

    it 'permalink based colleciton routing' do
    expect(:get => "/au/dresses/evening").to route_to("controller"   => "products/collections",
                                                      "action"       => "show",
                                                      "site_version" => "au",
                                                      "permalink"    => "evening")

  end

end

describe 'Product Redirection', type: :request do

  context 'customisation pages' do
    it_will :redirect,
            "/au/dresses/custom-first-in-line-467/white",
            "/au/dresses/dress-first-in-line-467/white"
  end

  context 'accessory pages' do
    it_will :redirect,
            "/au/dresses/styleit-first-in-line-467/white",
            "/au/dresses/dress-first-in-line-467/white"
  end

  context 'old taxon urls' do
    it_will :redirect, "dresses/color", "/dresses"
    it_will :redirect, "dresses/event", "/dresses"
    it_will :redirect, 'dresses/event/graduation', '/dresses/graduation'
    it_will :redirect, "dresses/style", "/dresses"
    it_will :redirect, 'dresses/style/long', '/dresses/long'
  end

  context 'colour pages' do
    it_will :redirect, '/dresses/colour/footpath_grey', '/dresses?colour=footpath_grey'
    it_will :redirect, '/dresses/color/sidewalk_gray',  '/dresses?color=sidewalk_gray'
  end

  context 'plus-size' do
    it_will :redirect, "/plus-size", '/dresses/plus-size'
  end
end
