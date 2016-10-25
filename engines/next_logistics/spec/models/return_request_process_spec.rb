require 'spec_helper'
require 'aasm/rspec'

module NextLogistics
  RSpec.describe ReturnRequestProcess do
    let(:order_return_request) { build(:order_return_request) }
    let(:return_request_process) { described_class.new(order_return_request: order_return_request) }

    it 'obeys state machines flow' do
      expect(return_request_process).to have_state(:created)
      expect(return_request_process).to transition_from(:created).to(:asn_file_uploaded).on_event(:asn_file_was_uploaded)
      expect(return_request_process).to transition_from(:asn_file_uploaded).to(:asn_received).on_event(:asn_was_received)
    end

    describe '#start_process' do
      context 'does not have items to return' do
        before(:each) do
          order_return_request.return_request_items = build_stubbed_list(:return_request_item, 2, :keep)
        end

        it 'does not persist process' do
          expect(return_request_process).not_to receive(:save!)
          return_request_process.start_process
        end
      end

      context 'has items to return' do
        before(:each) do
          order_return_request.return_request_items = [
            build_stubbed(:return_request_item, :keep),
            build_stubbed(:return_request_item, :return)
          ]
        end

        context 'in Australia' do
          before(:each) do
            order_return_request.order.ship_address.country.iso3 = 'AUS'
          end

          it 'persists process' do
            expect(return_request_process).to receive(:save!)
            return_request_process.start_process
          end
        end

        context 'outside of Australia' do
          before(:each) do
            order_return_request.order.ship_address.country.iso3 = 'BRA'
          end

          it 'does not save' do
            expect(return_request_process).not_to receive(:save!)
            return_request_process.start_process
          end
        end
      end
    end
  end
end
