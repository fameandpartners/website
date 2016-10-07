require 'spec_helper'
require 'aasm/rspec'
require_relative '../../support/return_item_ready_to_process_context'

module Bergen
  module Operations
    RSpec.describe ReturnItemProcess do
      let(:return_request_item) { build_stubbed(:return_request_item) }
      let(:return_item_process) { described_class.create(return_request_item: return_request_item) }

      it 'obeys state machines flow' do
        expect(return_item_process).to have_state(:operation_created)
        expect(return_item_process).to transition_from(:operation_created).to(:style_master_created).on_event(:style_master_was_created)
        expect(return_item_process).to transition_from(:style_master_created).to(:tracking_number_updated).on_event(:tracking_number_was_updated)
        expect(return_item_process).to transition_from(:tracking_number_updated).to(:asn_created).on_event(:asn_was_created)
        expect(return_item_process).to transition_from(:asn_created).to(:asn_received).on_event(:asn_was_received)
      end

      describe '#start_process' do
        let(:shipping_address) { build_stubbed(:address, country: country) }

        before do
          allow(return_request_item).to receive_message_chain(:order, :shipping_address).and_return(shipping_address)
        end

        context 'return is from the USA and for return' do
          let(:country) { build_stubbed(:country, :united_states) }
          let(:return_request_item) { build_stubbed(:return_request_item, :return) }

          it 'saves and call verification worker' do
            expect(return_item_process).to receive(:save!)

            return_item_process.start_process
          end
        end

        context 'return is not from the USA' do
          let(:country) { build_stubbed(:country, :australia) }
          let(:return_request_item) { build_stubbed(:return_request_item) }

          it 'does not save' do
            expect(return_item_process).not_to receive(:save!)

            return_item_process.start_process
          end
        end
      end

      describe '#update_tracking_number', :vcr  do
        include_context 'return item ready to process'

        let(:shippo_tracking_number) { '9205590164917321211369' }
        let(:shippo_label_url) { 'https://shippo-delivery-east.s3.amazonaws.com/fcdee5879ad540e993cd8b4a49d36add.pdf?Signature=b02Ci0NtViZgmAFx2YqTY9rMHpA%3D&Expires=1505651292&AWSAccessKeyId=AKIAJGLCC5MYLLWIG42A' }

        before do
          return_item_process.style_master_was_created!
        end

        it 'should get shippo tracking number and label URL'  do
          return_item_process.update_tracking_number
          expect(item_return.reload.shippo_tracking_number).to eql(shippo_tracking_number)
          expect(item_return.reload.shippo_label_url).to eql(shippo_label_url)
        end
      end
    end
  end
end
