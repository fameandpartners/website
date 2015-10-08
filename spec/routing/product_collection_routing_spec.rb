require 'spec_helper'

describe 'Product Collection Routes', type: :routing do

  describe 'temporary messaging' do
    context 'is enabled' do
      before do
        Features.activate(:getitquick_unavailable)
        FameAndPartners::Application.reload_routes!
      end

      it "shows an excellent demurment message" do
        expect(get: fast_making_dresses_path).to route_to(
          "controller"   => "hacky_messages",
          "action"       => "getitquick_unavailable"
        )
      end
    end

    context 'is disabled' do
      before do
        Features.deactivate(:getitquick_unavailable)
        FameAndPartners::Application.reload_routes!
      end
      it "shows fast making dresses" do
        expect(get: fast_making_dresses_path).to route_to(
          "controller"   => "products/collections",
          "action"       => "show",
          "fast_making"  =>  true
        )
      end
    end
  end
end
