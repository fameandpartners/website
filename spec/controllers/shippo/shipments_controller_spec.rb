require 'spec_helper'

describe Shippo::ShipmentsController, type: :controller do
  let(:wrong_request) {
    { metadata: 'Order R10000000', tracking_number: 'wrong_tracking_number' }
  }

  let(:right_request) {
    { metadata: 'Order R2000000', tracking_number: 'right_tracking_number' }
  }

  describe 'shippo' do
    it 'sends wrong request' do
      post :update, wrong_request
      expect(response).to have_http_status(200)
    end

    it 'sends right request' do
      create(:simple_shipping_method, name: 'UPS')
      order = create(:spree_order, number: 'R2000000')
      post :update, right_request
      expect(order.shipments.first.tracking).to eq('right_tracking_number')
      expect(response).to have_http_status(200)
    end
  end
end
