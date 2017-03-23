require 'spec_helper'

describe BulkRefundWorker do
  subject { described_class.new }

  let(:user) { FactoryGirl.create(:spree_user) }
  let!(:approved_item_returns) { FactoryGirl.create_list(:item_return, 3, acceptance_status: 'approved', order_payment_method: 'Pin', line_item_id: nil) }
  let!(:queued_item_returns) { FactoryGirl.create_list(:item_return, 3, acceptance_status: 'approved', order_payment_method: 'Pin') }
  let(:stubbed_line_item) { build_stubbed(:line_item, price: 42) }
  let(:item_return) { queued_item_returns.first }

  describe '#process' do
    before do
      allow_any_instance_of(ItemReturn).to receive(:line_item).and_return(stubbed_line_item)
      allow_any_instance_of(ItemReturnCalculator).to receive(:advance_refund)
    end

    it "creates refund events for all item returns in queue and report about refund" do
      is_expected.to receive(:report)

      subject.perform(user)

      queued_item_returns.each do |item_return|
        refund_event = item_return.events.refund.last

        expect(refund_event.event_type).to eq('refund')
        expect(refund_event.user).to eq(user)
        expect(refund_event.refund_amount).to eq(42)
        expect(refund_event.refund_method).to eq('Pin')
      end

      approved_item_returns.each do |item_return|
        expect(item_return.events.refund).to be_empty
      end
    end
  end

  describe '#report' do
    pending 'reports about processed refunds'
  end

  describe '#item_returns' do
    it "returns queued item returns" do
      expect(subject.send(:item_returns)).to eq(queued_item_returns)
    end
  end

  describe '#refund_amount_for' do
    before { allow_any_instance_of(ItemReturn).to receive(:line_item).and_return(stubbed_line_item) }

    it "returns refund amount equal to line item price" do
      expect(subject.send(:refund_amount_for, item_return)).to eq(42)
    end
  end

  describe '#refund' do
    before do
      subject.instance_variable_set('@user', user)
      allow_any_instance_of(ItemReturn).to receive(:line_item).and_return(stubbed_line_item)
      allow_any_instance_of(ItemReturnCalculator).to receive(:advance_refund)
    end

    it 'creates refund event for line item' do
      subject.send(:refund, item_return)

      refund_event = item_return.events.refund.last

      expect(refund_event.event_type).to eq('refund')
      expect(refund_event.user).to eq(user)
      expect(refund_event.refund_amount).to eq(42)
      expect(refund_event.refund_method).to eq('Pin')
    end
  end
end
