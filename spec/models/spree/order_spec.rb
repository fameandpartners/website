require 'spec_helper'

describe Spree::Order, :type => :model do
  subject(:order)     { FactoryGirl.create(:complete_order_with_items) }
  let(:completed_at)  { DateTime.parse('Wed April 1 2015') }


  before do
    allow(order).to receive(:complete?).and_return(true)
    allow(order).to receive(:completed_at).and_return(completed_at)
  end

  xit '#project_delivery_date' do
    expected_date = DateTime.parse('Wednesday April 15 2015')
    expect(order).to receive(:update_attribute).with(:projected_delivery_date, expected_date)
    order.project_delivery_date
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

  describe '#shipped?' do
    context 'shipped' do
      before do
        allow(order).to receive(:shipment_state).and_return('shipped')
      end
      it{ expect(order).to be_shipped }
    end

    context 'not shipped' do
      it 'when shipment status is other than shipped' do
        allow(order).to receive(:shipment_state).and_return('pending')

        expect(order).to_not be_shipped
      end

      it 'when shipment status is blank' do
        allow(order).to receive(:shipment_state).and_return(nil)

        expect(order).to_not be_shipped
      end
    end
  end

end
