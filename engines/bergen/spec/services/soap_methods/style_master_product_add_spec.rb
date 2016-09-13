require 'spec_helper'

module Bergen
  module SoapMethods
    RSpec.describe StyleMasterProductAdd, :vcr do
      let(:savon_client) { SavonClient.new }

      let(:order) { create(:complete_order_with_items) }
      let(:line_item) { order.line_items.first }
      let(:order_return_request) { create(:order_return_request, order: order) }
      let(:return_request_item) { create(:return_request_item, order_return_request: order_return_request, line_item: line_item) }

      let(:soap_method) { described_class.new(savon_client: savon_client, return_request_items: [return_request_item]) }

      it 'adds some variants to WMS queue' do
        expect(soap_method.result).to eq({ error_code: '0', severity: 'Success', message: 'Data saved successfully' })
      end
    end
  end
end
