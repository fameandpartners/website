require 'spec_helper'

describe 'Product Collection Routes', type: :routing do
  it "shows fast making dresses" do
    expect(get: fast_making_dresses_path).to route_to(
      "controller"   => "products/collections",
      "action"       => "show",
      "fast_making"  =>  true
    )
  end
end
