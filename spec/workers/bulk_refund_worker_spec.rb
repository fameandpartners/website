require 'spec_helper'

describe BulkRefundWorker do
  subject { described_class.new }

  let(:user) { FactoryGirl.create(:spree_user) }
  let(:queued_item_returns) { FactoryGirl.create_list(:item_return, 3, acceptance_status: 'approved') }

  describe '#item_returns' do
  end

  describe '#refund_amount_for' do
  end

  describe '#refund' do
    let(:item_return) { queued_item_returns.first }

    before do
      subject.instance_variable_set('@user', user)
      allow_any_instance_of(ItemReturn).to receive(:line_item).and_return(double(:line_item, price: 42))
      allow_any_instance_of(ItemReturnCalculator).to receive(:advance_refund)
    end

    it 'creates refund event for line item' do
      subject.send(:refund, item_return)

      refund_event = item_return.events.last

      expect(refund_event.event_type).to eq('refund')
      expect(refund_event.user).to eq(user)
      expect(refund_event.refund_amount).to eq(42)
      expect(refund_event.refund_method).to eq('Pin')
    end
  end
end
