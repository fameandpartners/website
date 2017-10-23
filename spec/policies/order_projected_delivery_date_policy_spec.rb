require 'spec_helper'

describe Policies::OrderProjectedDeliveryDatePolicy, type: :policy do
  let(:completed_at) { DateTime.parse('Wed April 1 2015') }

  subject(:policy) { described_class.new(order) }

  context '#delivery_date' do
    context 'china new year delivery delay' do
      # let(:order) { double(Spree::Order, completed_at: completed_at, has_fast_making_items?: false, has_slow_making_items?: false) }
      let(:order) { FactoryGirl.create(:complete_order_with_items, completed_at: completed_at) }
      let(:expected_date) { DateTime.parse('Tue April 21 2015') }

      xit 'calculates 28 calendar days on china new year period' do
        Features.activate(:cny_delivery_delays)

        # expected_date = DateTime.parse('Tue, 28 Apr 2015')
        expect(policy.delivery_date).to eq expected_date
      end
    end

    context 'order is for standard delivery' do
      let(:order) { FactoryGirl.create(:complete_order_with_items) }
      let(:expected_date) { DateTime.parse('Tue April 28 2015') }

      it 'calculates 10 business days' do
        Time.zone do
          Timecop.freeze('April 15 2015') do
            expect(policy.delivery_date).to eql expected_date
          end
        end
      end
    end

    context 'order is for express delivery' do
      # let(:order) { double(Spree::Order, completed_at: completed_at, has_fast_making_items?: true) }
      let(:order) { FactoryGirl.create(:complete_order_with_items_fast, completed_at: completed_at) }

      xit 'calculates 5 business days' do
        expected_date = Date.parse('Friday April 8 2015')
        expect(policy.delivery_date).to eq expected_date
      end
    end
  end
end
