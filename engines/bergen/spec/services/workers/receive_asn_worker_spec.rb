require 'spec_helper'
require 'aasm/rspec'

require 'sidekiq/testing/inline'
require_relative '../../support/return_item_ready_to_process_context'

module Bergen
  module Workers
    RSpec.describe ReceiveAsnWorker, :vcr do
      include_context 'return item ready to process'

      let(:worker) { described_class.new }

      before(:each) do
        return_item_process.style_master_was_created!
        return_item_process.asn_was_created!
      end

      context 'given a return item process id' do
        context 'if ASN was received' do
          it 'marks asn as received' do
            worker.perform(return_item_process.id)

            expect(return_item_process).to have_state(:asn_received)

            event = item_return.events.last
            expect(event.event_type).to eq('bergen_asn_received')
            expect(event.data).to eq({
                                       'actual_quantity'         => '1',
                                       'color'                   => 'red',
                                       'damaged_quantity'        => '0',
                                       'expected_quantity'       => '1',
                                       'product_msrp'            => '123.45',
                                       'shipment_type'           => 'NA',
                                       'size'                    => 'au 4/us 0',
                                       'style'                   => 'abc123',
                                       'unit_cost'               => '0',
                                       'upc'                     => '10001',
                                       'added_to_inventory_date' => '05/23/2016 12:47:13',
                                       'arrived_date'            => '05/23/2016',
                                       'created_date'            => '5/23/2016 12:32:50 PM',
                                       'expected_date'           => '5/10/2016',
                                       'memo'                    => 'Sample Memo Woot',
                                       'receiving_status'        => 'AddedToInventory',
                                       'receiving_status_code'   => '600',
                                       'warehouse'               => 'BERGEN LOGISTICS NJ2'
                                     })
          end
        end

        context 'if ASN was not received' do
          # ASN is going to response Draft status

          it 'verifies it again in a few hours' do
            worker.perform(return_item_process.id)

            expect(return_item_process).to have_state(:asn_created)
          end
        end

        context 'ASN does not exists' do
          it do
            item_return.bergen_asn_number = 'I-DO-NOT-EXIST'
            item_return.save

            worker.perform(return_item_process.id)

            expect(return_item_process).to have_state(:asn_created)
          end
        end

        context 'an exception is raised' do
          let(:sentry_error) { double('Sentry Error', id: 'sentry-error-id') }

          it 'mark as failed and save Sentry id' do
            expect(return_item_process).to receive(:return_request_item).and_raise(StandardError)
            expect(Raven).to receive(:capture_exception).with(StandardError).and_return(sentry_error)

            worker.perform(return_item_process.id)

            expect(return_item_process.sentry_id).to eq('sentry-error-id')
            expect(return_item_process.failed).to eq(true)
          end
        end
      end
    end
  end
end
