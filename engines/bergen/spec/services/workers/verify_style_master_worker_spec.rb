require 'spec_helper'
require 'aasm/rspec'

module Bergen
  module Workers
    RSpec.describe VerifyStyleMasterWorker do
      let!(:return_request_item) { build_stubbed(:return_request_item) }
      let!(:return_item_process) { Operations::ReturnItemProcess.create(return_request_item: return_request_item) }
      let!(:worker) { described_class.new }

      context 'given a return item process id' do
        describe 'verify if style master was created' do
          context 'success' do
            before do
              allow(worker).to receive(:style_master_status).and_return(described_class::SUCCESS)
            end

            it do
              expect(worker).to receive(:advance_in_return_item_process)

              worker.perform(return_item_process.id)
            end
          end

          context 'not created yet' do
            before do
              allow(worker).to receive(:style_master_status).and_return(described_class::UPC_CODE_ERROR)
            end

            it do
              expect(worker).to receive(:create_style_master)
              expect(worker).to receive(:verify_again_in_few_minutes)

              worker.perform(return_item_process.id)
            end
          end

          context 'pending importation' do
            before do
              allow(worker).to receive(:style_master_status).and_return(described_class::PENDING_IMPORT)
            end

            it do
              expect(worker).to receive(:verify_again_in_few_minutes)

              worker.perform(return_item_process.id)
            end
          end

          context 'error' do
            pending 'Error handling not implemented yet'
          end
        end
      end
    end
  end
end
