require 'spec_helper'

describe Spree::Calculator::SaleShipping, type: :model do
  let(:order) { build(:spree_order) }

  let(:subject) { Spree::Calculator::SaleShipping.new(
    preferred_sale_products_shipping_amount:    15.5,
    preferred_normal_products_shipping_amount:  9.9
  )}

  context "#compute" do
    context 'orders' do
      it "returns default shipping for standard orders" do
        expect(order).to receive(:in_sale?).and_return(false)
        expect(subject.compute(order)).to eql(BigDecimal.new('9.9'))
      end

      it "returns sale amount for orders with sale items" do
        expect(order).to receive(:in_sale?).and_return(true)
        expect(subject.compute(order)).to eql(BigDecimal.new('15.5'))
      end
    end

    context 'promotions' do
      it "returns sale amount if applied promotion requires charge" do
        expect(order).to receive(:coupon_code_added_promotion).and_return(
          double('promo', require_shipping_charge?: true)
        )

        expect(subject.compute(order)).to eql(BigDecimal.new('15.5'))
      end

      it "returns default amount if applied promotion requires charge" do
        expect(order).to receive(:coupon_code_added_promotion).and_return(
          double('promo', require_shipping_charge?: false)
        )

        expect(subject.compute(order)).to eql(BigDecimal.new('9.9'))
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
