require 'spec_helper'
require 'aasm/rspec'

require 'sidekiq/testing/inline'
require_relative '../../support/return_item_ready_to_process_context'

module Bergen
  module Workers
    RSpec.describe VerifyStyleMasterWorker, :vcr do
      include_context 'return item ready to process'

      let(:worker) { described_class.new }

      context 'given a return item process id' do
        describe 'verify if style master was created' do
          context 'success' do
            it do
              expect(return_item_process).to receive(:create_asn)

              worker.perform(return_item_process.id)

              expect(return_item_process).to have_state(:style_master_created)
            end
          end

          context 'not created yet' do
            it do
              expect(described_class).to receive(:perform_in).with(30.minutes, return_item_process.id)

              worker.perform(return_item_process.id)
            end
          end

          context 'pending importation' do
            it do
              expect(described_class).to receive(:perform_in).with(30.minutes, return_item_process.id)

              worker.perform(return_item_process.id)
            end
          end

          context 'error' do
            it do
              # TODO 'Error handling not implemented yet'
              # TODO: at least record VCR call

              worker.perform(return_item_process.id)
            end
          end
        end
      end
    end
  end
end
