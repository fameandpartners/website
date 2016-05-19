require 'spec_helper'
require 'aasm/rspec'

require 'engines/bergen/spec/support/return_item_ready_to_process_context'

module Bergen
  module Workers
    RSpec.describe CreateAsnWorker, :vcr do
      include_context 'return item ready to process'

      let(:worker) { described_class.new }

      before(:each) do
        return_item_process.style_master_was_created!
      end

      context 'given a return item process id' do
        it 'creates ASN, triggers item returns event sourcing and trigger next step' do
          expect(return_item_process).to receive(:receive_asn)

          worker.perform(return_item_process.id)

          asn_event = return_request_item.item_return.events.bergen_asn_created.first
          expect(asn_event.data['asn_number']).to eq('WHRTN915392')
          expect(return_item_process).to have_state(:asn_created)
        end
      end
    end
  end
end
