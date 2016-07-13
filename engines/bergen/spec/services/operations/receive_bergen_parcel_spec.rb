require 'spec_helper'

module Bergen
  module Operations
    RSpec.describe ReceiveBergenParcel, type: :operation do
      let(:operation) { described_class.new(item_return: item_return) }

      before(:each) do
        # TODO: 13/07/2016 temporarily disabling customer facing emails due to worker triggering too many times
        # expect(CustomerMailer).to receive_message_chain(:received_parcel, :deliver)
      end

      context 'Rejects parcel' do
        let(:item_return) { create(:item_return, :bergen_rejected, acceptance_status: 'any status') }

        it do
          expect(CustomerServiceMailer).to receive_message_chain(:rejected_parcel, :deliver)

          operation.process

          expect(item_return.reload.acceptance_status).to eq('rejected')
        end
      end

      context 'Accepts parcel' do
        let(:item_return) { create(:item_return, :bergen_accepted, acceptance_status: 'any status') }

        it do
          expect(CustomerServiceMailer).to receive_message_chain(:accepted_parcel, :deliver)

          operation.process

          expect(item_return.reload.acceptance_status).to eq('approved')
        end
      end
    end
  end
end
