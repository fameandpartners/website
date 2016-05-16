require 'spec_helper'
require 'aasm/rspec'

module Bergen
  module Operations
    RSpec.describe ReturnItemProcess do
      let(:return_request_item) { build_stubbed(:return_request_item) }
      let(:return_item_process) { described_class.create(return_request_item: return_request_item) }

      it 'obeys state machines flow' do
        expect(return_item_process).to transition_from(:operation_created).to(:style_master_created).on_event(:style_master_was_created)
        expect(return_item_process).to transition_from(:style_master_created).to(:asn_created).on_event(:create_asn)
        expect(return_item_process).to transition_from(:asn_created).to(:asn_received).on_event(:receive_asn)
      end

      describe '#start_process' do
        let(:shipping_address) { build_stubbed(:address, country: country) }
        let(:return_request_item) { build_stubbed(:return_request_item) }

        before do
          allow(return_request_item).to receive_message_chain(:order, :shipping_address).and_return(shipping_address)
        end

        context 'return is from the USA' do
          let(:country) { build_stubbed(:country, :united_states) }

          it 'saves and call verification worker' do
            expect(return_item_process).to receive(:save!)
            expect(Workers::VerifyStyleMasterWorker).to receive(:perform_async).with(return_item_process.id)

            return_item_process.start_process
          end
        end

        context 'return is not from the USA' do
          let(:country) { build_stubbed(:country, :australia) }

          it 'does not save' do
            expect(return_item_process).not_to receive(:save!)

            return_item_process.start_process
          end
        end
      end
    end
  end
end
