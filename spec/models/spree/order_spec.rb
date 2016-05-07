require 'spec_helper'

describe Spree::Order, :type => :model do
  subject(:order)     { Spree::Order.new }
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

  describe '#returnable?' do
    let(:line_item) { build(:line_item, fabrication: fabrication) }
    let(:order) { build(:spree_order, line_items: [line_item]) }

    before(:each) { allow(order).to receive(:order_return_requested?).and_return(false) }

    context 'given that all line items are shipped' do
      let(:fabrication) { build(:fabrication, :shipped) }

      it { expect(order.returnable?).to be_truthy }

      context 'order has an opened return request' do
        before(:each) { allow(order).to receive(:order_return_requested?).and_return(true) }

        it { expect(order.returnable?).to be_falsey }
      end
    end

    context 'a single line item is not shipped' do
      let(:fabrication) { build(:fabrication, state: 'anything') }

      it { expect(order.returnable?).to be_falsey }
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
      before do
        allow(order).to receive(:shipment_state).and_return('pending')
      end
      it{ expect(order).to_not be_shipped }
    end
  end

  describe 'associate user when guest checkout based on email, first name and last name' do
    context 'guest checkout' do
      let(:match_user) { create(:spree_user, email: 'something@music.com', first_name: 'Something', last_name: 'Music') }
      it 'should associate user' do
        result = GuestCheckoutAssociation.associate_user_for_guest_checkout(order, nil,  {"bill_address_attributes" => {"email" => match_user.email, "firstname" => 'Something', "lastname" => 'Music'}})
        expect(result).to be true
        expect(order.user).to eq(match_user)
      end
      it 'should not associate user with correct email and incorrect first/last name' do
        result = GuestCheckoutAssociation.associate_user_for_guest_checkout(order, nil,  {"bill_address_attributes" => {"email" => match_user.email, "firstname" => "", "lastname" => ""}})
        expect(result).to be false
        expect(order.user).to be_nil
      end
    end
  end
end
