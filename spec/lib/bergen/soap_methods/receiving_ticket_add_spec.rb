require 'spec_helper'

module Bergen
  module SoapMethods
    RSpec.describe ReceivingTicketAdd, :vcr do
      let(:order) { create(:complete_order_with_items) }
      let(:line_item) { order.line_items.first }
      let(:order_return_request) { create(:order_return_request, order: order) }
      let(:return_request_item) { create(:return_request_item, order_return_request: order_return_request, line_item: line_item) }

      let(:savon_client) { SavonClient.new }
      let(:soap_method) { described_class.new(savon_client: savon_client, return_request_item: return_request_item) }

      describe 'creates a new receiving ticket' do
        context 'successfully creates' do
          it do
            expect(soap_method.result).to eq({
                                               receiving_ticket_id: 'WHRTN915364'
                                             })
          end
        end

        context 'fail to create' do
          pending 'No fail scenario yet'
        end
      end
    end
  end
end
