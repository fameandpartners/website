require 'spec_helper'

describe Spree::Order do
  let(:order)         { Spree::Order.new }
  let(:completed_at)  { DateTime.parse('Wed April 1 2015') }

  before do
    allow(order).to receive(:complete?).and_return(true)
    allow(order).to receive(:completed_at).and_return(completed_at)
  end

  it '#project_delivery_date' do
    expected_date = DateTime.parse('Friday April 10 2015')
    expect(order).to receive(:update_attribute).with(:projected_delivery_date, expected_date)
    order.project_delivery_date
  end

  describe 'order delivery state' do

    context 'incomplete' do
      before do
        allow(order).to receive(:complete?).and_return(false)
      end

      it 'should be ok' do
        expect(order.delivery_state).to eq 'incomplete'
      end
    end

    context 'more than 2 days before due date' do
      before do
        expect(order).to receive(:projected_delivery_date).twice.and_return(5.days.since)
      end

      it 'should be ok' do
        expect(order.delivery_state).to eq 'ok'
      end
    end

    context '1 days before due date' do
      before do
        expect(order).to receive(:projected_delivery_date).twice.and_return(1.days.since)
      end

      it 'should be due' do
        expect(order.delivery_state).to eq 'due'
      end
    end

    context '3 days after due date' do
      before do
        expect(order).to receive(:projected_delivery_date).twice.and_return(3.days.ago)
      end

      it 'should be overdue' do
        expect(order.delivery_state).to eq 'overdue'
      end
    end

    context '7 days after due date' do
      before do
        expect(order).to receive(:projected_delivery_date).twice.and_return(7.days.ago)
      end

      it 'should be overdue' do
        expect(order.delivery_state).to eq 'urgent'
      end
    end

    context 'overdue > 1 week' do

      before do
        expect(order).to receive(:projected_delivery_date).twice.and_return(12.days.ago)
      end

      it 'should be critical' do
        expect(order.delivery_state).to eq 'critical'
      end

    end

  end


end
