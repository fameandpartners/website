require 'spec_helper'
require 'aasm/rspec'

module NextLogistics
  RSpec.describe ReturnRequestProcess do
    let(:order_return_request) { build_stubbed(:order_return_request) }
    let(:return_request_process) { described_class.create(order_return_request: order_return_request) }

    it 'obeys state machines flow' do
      expect(return_request_process).to have_state(:created)
      expect(return_request_process).to transition_from(:created).to(:asn_file_uploaded).on_event(:asn_file_was_uploaded)
      expect(return_request_process).to transition_from(:asn_file_uploaded).to(:asn_received).on_event(:asn_was_received)
    end

    describe '#start_process' do
      # TODO: based on Bergen?
      # let(:shipping_address) { build_stubbed(:address, country: country) }
      #
      # before do
      #   allow(return_request_item).to receive_message_chain(:order, :shipping_address).and_return(shipping_address)
      # end
      #
      # context 'return is from the USA and for return' do
      #   let(:country) { build_stubbed(:country, :united_states) }
      #   let(:return_request_item) { build_stubbed(:return_request_item, :return) }
      #
      #   it 'saves and call verification worker' do
      #     expect(return_request_process).to receive(:save!)
      #
      #     return_request_process.start_process
      #   end
      # end
      #
      # context 'return is not from the USA' do
      #   let(:country) { build_stubbed(:country, :australia) }
      #   let(:return_request_item) { build_stubbed(:return_request_item) }
      #
      #   it 'does not save' do
      #     expect(return_request_process).not_to receive(:save!)
      #
      #     return_request_process.start_process
      #   end
      # end
    end
  end
end
