require 'spec_helper'
require 'aasm/rspec'

module Bergen
  module Workers
    RSpec.describe CreateAsnWorker do
      let!(:return_request_item) { build_stubbed(:return_request_item) }
      let!(:return_item_process) { Operations::ReturnItemProcess.create(return_request_item: return_request_item) }
      let!(:worker) { described_class.new }

      context 'given a return item process id' do
        it 'creates ASN, triggers item returns event sourcing and trigger next step' do
          expect(worker).to receive(:create_asn).and_return('FAKE_ASN_NUMBER')
          expect(worker).to receive(:create_asn_retrieval_event).with('FAKE_ASN_NUMBER')
          expect(worker).to receive(:advance_in_return_item_process)

          worker.perform(return_item_process.id)
        end
      end
    end
  end
end
