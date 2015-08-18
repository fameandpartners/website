require 'spec_helper'

# require 'app/controllers/spree/checkout_controller_decorator'

module Spree
  RSpec.describe CheckoutController, :type => :controller do
    describe 'view versions' do
      before do
        seed_site_zone
      end

      xit do
        def controller.load_order
          @order = current_order
        end
        allow_any_instance_of(described_class).to receive(:skip_state_validation?).and_return(true)
        get :edit
        expect(response).to render_template('/app/views/checkout/v1/spree/checkout/edit')
      end
    end
  end
end
