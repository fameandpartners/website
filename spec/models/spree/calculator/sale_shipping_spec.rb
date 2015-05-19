require 'spec_helper'

describe Spree::Calculator::SaleShipping, type: :model do
  let(:order) { build(:spree_order) }

  let(:subject) { Spree::Calculator::SaleShipping.new(
    preferred_sale_products_shipping_amount:    15.5,
    preferred_normal_products_shipping_amount:  9.9
  )}

  context "#compute" do
    it "returns free shipping for standard orders" do
      expect(order).to receive(:in_sale?).and_return(true)
      expect(subject.compute(order)).to eql(BigDecimal.new('15.5'))
    end

    it "returns sale amount for orders with sale items" do
      expect(order).to receive(:in_sale?).and_return(false)
      expect(subject.compute(order)).to eql(BigDecimal.new('9.9'))
    end
  end
end
