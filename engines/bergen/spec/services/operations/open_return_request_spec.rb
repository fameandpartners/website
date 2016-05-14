require 'spec_helper'

module Bergen
  module Operations
    RSpec.describe ReturnItemProcess do
      let(:return_request_items) { double('Return Request Items') }
      let(:bergen_service) { double('Bergen Service') }

      describe '.process' do
        before(:each) { allow(described_class).to receive(:service).and_return(bergen_service) }

        it do
          expect(bergen_service).to receive(:style_master_product_add_by_return_request_items).with(return_items: return_request_items)

          described_class.process(return_request_items: return_request_items)
        end
      end
    end
  end
end
