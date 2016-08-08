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
