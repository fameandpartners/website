require 'spec_helper'
require 'aasm/rspec'

module Bergen
  module Operations
    RSpec.describe ReturnItemProcess do
      let(:return_request_item) { build_stubbed(:return_request_item) }
      subject(:return_item_process) { described_class.create(return_request_item: return_request_item) }
      let(:process_id) { return_item_process.id }

      it 'obeys state machines flow' do
        is_expected.to have_state(:operation_created)
        is_expected.to transition_from(:operation_created).to(:style_master_created).on_event(:style_master_was_created)
        is_expected.to transition_from(:style_master_created).to(:tracking_number_updated).on_event(:tracking_number_was_updated)
        is_expected.to transition_from(:tracking_number_updated).to(:asn_created).on_event(:asn_was_created)
        is_expected.to transition_from(:asn_created).to(:asn_received).on_event(:asn_was_received)
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

      describe '#verify_style_master' do
        context 'when process is at the "operation_created" state' do
          before(:each) { return_item_process.update_attribute(:aasm_state, 'operation_created') }

          it 'calls upload to FTP worker' do
            expect(Workers::VerifyStyleMasterWorker).to receive(:perform_async).with(process_id)

            return_item_process.verify_style_master
          end
        end

        context 'when process is not at the "operation_created" state' do
          before(:each) { return_item_process.update_attribute(:aasm_state, 'style_master_created') }

          it 'does not call upload to FTP worker' do
            expect(Workers::VerifyStyleMasterWorker).not_to receive(:perform_async)

            return_item_process.verify_style_master
          end
        end
      end

      describe '#update_tracking_number' do
        context 'when process is at the "style_master_created" state' do
          before(:each) { return_item_process.update_attribute(:aasm_state, 'style_master_created') }

          it 'proceeds to next state' do
            return_item_process.update_tracking_number
            return_item_process.reload
            expect(return_item_process.aasm_state).to eq('tracking_number_updated')
          end
        end

        context 'when process is not at the "style_master_created" state' do
          before(:each) { return_item_process.update_attribute(:aasm_state, 'tracking_number_updated') }

          it 'does nothing to the process state' do
            return_item_process.update_tracking_number
            return_item_process.reload
            expect(return_item_process.aasm_state).to eq('tracking_number_updated')
          end
        end
      end

      describe '#create_asn' do
        context 'when process is at the "tracking_number_updated" state' do
          before(:each) { return_item_process.update_attribute(:aasm_state, 'tracking_number_updated') }

          it 'calls upload to FTP worker' do
            expect(Workers::CreateAsnWorker).to receive(:perform_async).with(process_id)

            return_item_process.create_asn
          end
        end

        context 'when process is not at the "tracking_number_updated" state' do
          before(:each) { return_item_process.update_attribute(:aasm_state, 'asn_created') }

          it 'does not call upload to FTP worker' do
            expect(Workers::CreateAsnWorker).not_to receive(:perform_async)

            return_item_process.create_asn
          end
        end
      end

      describe '#receive_asn' do
        context 'when process is at the "asn_created" state' do
          before(:each) { return_item_process.update_attribute(:aasm_state, 'asn_created') }

          it 'calls upload to FTP worker' do
            expect(Workers::ReceiveAsnWorker).to receive(:perform_async).with(process_id)

            return_item_process.receive_asn
          end
        end

        context 'when process is not at the "asn_created" state' do
          before(:each) { return_item_process.update_attribute(:aasm_state, 'asn_received') }

          it 'does not call upload to FTP worker' do
            expect(Workers::ReceiveAsnWorker).not_to receive(:perform_async)

            return_item_process.receive_asn
          end
        end
      end
    end
  end
end
