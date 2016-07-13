require 'spec_helper'
require 'aasm/rspec'

require 'sidekiq/testing/inline'
require_relative '../../support/return_item_ready_to_process_context'

module Bergen
  module Workers
    RSpec.describe CreateAsnWorker, :vcr do
      include_context 'return item ready to process'

      let(:worker) { described_class.new }
      let(:asn_date) { Date.parse('10/10/2016') } # Simple Date.today call. No need for TimeCop

      before(:each) do
        return_item_process.style_master_was_created!
        allow(Date).to receive(:today).and_return(asn_date)
      end

      context 'given a return item process id' do
        it 'creates ASN, triggers item returns event sourcing and trigger next step' do
          expect(return_item_process).to receive(:receive_asn)

          worker.perform(return_item_process.id)

          asn_event = return_request_item.item_return.events.bergen_asn_created.first
          expect(asn_event.data['asn_number']).to eq('WHRTN1044588')
          expect(return_item_process).to have_state(:asn_created)
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
