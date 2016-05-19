require 'spec_helper'
require 'aasm/rspec'

require 'engines/bergen/spec/support/return_item_ready_to_process_context'

module Bergen
  module Workers
    RSpec.describe ReceiveAsnWorker do
      include_context 'return item ready to process'

      let(:worker) { described_class.new }

      before(:each) do
        return_item_process.style_master_was_created!
        return_item_process.asn_was_created!
      end

      context 'given a return item process id' do
        context 'if ASN was received' do
          # before(:each) { expect(worker).to receive(:item_was_received?).and_return(true) }

          it 'marks asn as received' do
            expect(worker).to receive(:mark_asn_as_received)

            worker.perform(return_item_process.id)
          end
        end

        context 'if ASN was not received' do
          before(:each) { expect(worker).to receive(:item_was_received?).and_return(false) }

          it 'verifies it again in a few hours' do
            expect(described_class).to receive(:perform_in).with(3.hours, return_item_process.id)

            worker.perform(return_item_process.id)
          end
        end
      end
    end
  end
end
