require 'spec_helper'

describe Spree::Order, :type => :model do
  subject(:order)    { Spree::Order.new }
  let(:completed_at) { DateTime.parse('Wed April 1 2015') }


  describe '#project_delivery_date' do
    let(:expected_date) { DateTime.parse('Friday April 10 2015') }

    before(:each) do
      allow(order).to receive(:complete?).and_return(true)
      allow(order).to receive(:completed_at).and_return(completed_at)
    end

    it 'updates projected delivery date attribute of an order' do
      expect(order).to receive(:update_attribute).with(:projected_delivery_date, expected_date)
      order.project_delivery_date
    end
  end

  describe '#promotions' do
    # order.adjustments.promotions.originator.promotion
    it 'new order doesnt have any promotions' do
      expect(order.promotions).to be_blank
    end
  end

  describe '#promocode' do
    it 'returns code only from coupon_code type promotions' do
      expect(order).to receive(:promotions).and_return([
        double('promo', code: 'IMFAME', event_name: "spree.checkout.another_code"),
        double('promo', code: 'FAME', event_name: "spree.checkout.coupon_code_added")
      ])
      expect(order.promocode).to eq('FAME')
    end
  end

  describe 'shipped' do
    context 'shipped' do
      before do
        allow(order).to receive(:shipment_state).and_return('shipped')
      end
      it{ expect(order).to be_shipped }
    end
    context 'not shipped' do
      before do
        allow(order).to receive(:shipment_state).and_return('pending')
      end
      it{ expect(order).to_not be_shipped }
    end
  end

  describe 'before completion' do
    context 'order does not have line items' do
      let(:order) { build_stubbed(:spree_order, state: :payment, number: 'R1234') }

      it 'cannot proceed to order completion, raising an error' do
        expect { order.next }.to raise_error(Errors::Orders::NoLineItems).with_message('Cannot complete order R1234 with no line items')
      end
    end

    context 'order have line items' do
      let(:line_items) { build_stubbed_list(:dress_item, 2) }
      let(:order)      { build_stubbed(:spree_order, state: :payment, line_items: line_items) }

      it 'can proceed to completion' do
        expect { order.next }.not_to raise_error
      end
    end
  end
end
