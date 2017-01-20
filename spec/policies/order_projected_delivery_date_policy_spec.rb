require 'spec_helper'

describe Policies::OrderProjectedDeliveryDatePolicy, type: :policy do
  let(:completed_at) { DateTime.parse('Wed April 1 2015') }

  subject(:policy) { described_class.new(order) }

  context '#delivery_date' do
    context 'china new year delivery delay' do
      let(:order) { double(Spree::Order, completed_at: completed_at) }

      it 'calculates 28 calendar days on china new year period' do
        Features.activate(:cny_delivery_delays)

        expected_date = DateTime.parse('Wed 29 Apr 2015')
        expect(policy.delivery_date).to eq expected_date
      end
    end

    context 'order is for standard delivery' do
      let(:order) { double(Spree::Order, completed_at: completed_at, has_fast_making_items?: false) }

      it 'calculates 10 business days' do
        expected_date = DateTime.parse('Friday April 15 2015')
        expect(policy.delivery_date).to eq expected_date
      end
    end

    context 'order is for express delivery' do
      let(:order) { double(Spree::Order, completed_at: completed_at, has_fast_making_items?: true) }

      it 'calculates 4 business days' do
        expected_date = DateTime.parse('Friday April 7 2015')
        expect(policy.delivery_date).to eq expected_date
      end
    end
  end
end
