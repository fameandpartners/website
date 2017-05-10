require 'spec_helper'

describe Policies::LineItemProjectedDeliveryDatePolicy, type: :policy do
  let(:completed_at) { DateTime.parse('Wed April 1 2015') }
  let(:order) { double(Spree::Order, completed_at: completed_at) }

  subject(:policy) { described_class.new(order.completed_at, line_item.fast_making?) }

  context '#delivery_date' do
    context 'line item is for standard delivery' do
      let(:line_item) { double(Spree::LineItem, fast_making?: false) }

      it 'calculates 7 business days' do
        expected_date = DateTime.parse('Friday April 10 2015')
        expect(policy.delivery_date).to eq expected_date
      end
    end

    context 'line item is for express delivery' do
      let(:line_item) { double(Spree::LineItem, fast_making?: true) }

      it 'calculates 4 business days' do
        expected_date = DateTime.parse('Friday April 7 2015')
        expect(policy.delivery_date).to eq expected_date
      end
    end
  end
end
