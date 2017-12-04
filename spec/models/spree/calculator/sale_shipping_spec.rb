require 'spec_helper'

describe Spree::Calculator::SaleShipping, type: :model do
  let(:order) { build(:spree_order) }

  subject(:calculator) { Spree::Calculator::SaleShipping.new(
    preferred_sale_products_shipping_amount:   0,
    preferred_normal_products_shipping_amount:  9.9,
    preferred_international_shipping_fee:       30.0
  )}

  matcher :be_default_charge do
    match { |actual| actual == BigDecimal.new('9.9') }
    failure_message do |actual|
      "expected that #{actual.to_f} would be the default shipping charge (9.9)"
    end
  end

  matcher :be_extra_charge do
    match { |actual| actual == BigDecimal.new('15.5') }
    failure_message do |actual|
      "expected that #{actual.to_f} would be the extra shipping charge (15.5)"
    end
  end

  matcher :be_international_shipping_fee_with_default_charge do
    match { |actual| actual == BigDecimal.new('39.9') }
    failure_message do |actual|
      "expected that #{actual.to_f} would be the international shipping fee with default shipping charge (39.9)"
    end
  end

  context "#compute" do
    subject(:shipping_amount) { calculator.compute(order) }

    context 'orders' do
      it "default shipping for standard orders" do
        allow(order).to receive(:in_sale?).and_return(false)

        expect(shipping_amount).to be_default_charge
      end

      xit "extra shipping for orders with sale items" do
        allow(order).to receive(:in_sale?).and_return(true)

        expect(shipping_amount).to be_extra_charge
      end
    end

    context 'promotions' do
      xit "applied promotion requires shipping charge" do
        allow(order).to receive(:coupon_code_added_promotion).and_return(
          double('promo', require_shipping_charge?: true)
        )

        expect(shipping_amount).to be_extra_charge
      end

      it "applied promotion does not require shipping charge" do
        allow(order).to receive(:coupon_code_added_promotion).and_return(
          double('promo', require_shipping_charge?: false)
        )

        expect(shipping_amount).to be_default_charge
      end
    end

    context 'international shipping fee' do
      let(:zone_member) { Spree::ZoneMember.new }

      before do
        allow(order.shipping_address.country).to receive(:zone_member).and_return(zone_member)
      end

      it 'international shipping fee for orders to zone member with shipping fee' do
        allow(zone_member).to receive(:has_international_shipping_fee).and_return(true)
        expect(shipping_amount).to be_international_shipping_fee_with_default_charge
      end

      it 'no international shipping fee for orders to zone member without shipping fee' do
        allow(zone_member).to receive(:has_international_shipping_fee).and_return(false)
        expect(shipping_amount).to be_default_charge
      end
    end
  end

  context "has_items_in_sale?" do
    it "returns false for empty order" do
      expect(subject.has_items_in_sale?(order)).to be false
    end
  end

  context "#promotion_require_shipping_charge" do
    it "returns false for empty order" do
      expect(subject.promotion_require_shipping_charge?(order)).to be false
    end
  end
end
