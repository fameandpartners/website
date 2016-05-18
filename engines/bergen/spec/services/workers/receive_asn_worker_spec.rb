require 'spec_helper'
require 'aasm/rspec'

module Bergen
  module Workers
    RSpec.describe ReceiveAsnWorker do
      let!(:return_request_item) { build_stubbed(:return_request_item) }
      let!(:return_item_process) { Operations::ReturnItemProcess.create(return_request_item: return_request_item) }
      let!(:worker) { described_class.new }

      context 'given a return item process id' do
        context 'if ASN was received' do
          before(:each) { expect(worker).to receive(:item_was_received?).and_return(true) }

          it 'marks asn as received' do
            expect(worker).to receive(:mark_asn_as_received)

            worker.perform(return_item_process.id)
          end
        end

        context 'if ASN was not received' do
          before(:each) { expect(worker).to receive(:item_was_received?).and_return(false) }

          it 'verifies it again in a few hours' do
            expect(worker).to receive(:verify_again_in_few_hours)

            worker.perform(return_item_process.id)
          end
        end
      end
    end
  end
end
