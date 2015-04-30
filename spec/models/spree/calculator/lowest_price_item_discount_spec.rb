require 'spec_helper'

describe Spree::Calculator::LowestPriceItemDiscount, type: :model do
  context "compute" do
    let(:subject) { Spree::Calculator::LowestPriceItemDiscount.new(
      preferred_discount: 30, preferred_items_count: 1)
    }
    let(:order) { build(:spree_order) }

    it "returns 0 for empty cart" do
      result = subject.compute(order).abs
      expect(subject.compute(order).abs).to eql(BigDecimal.new(0))
    end

    it "returns 0 for cart with single item" do
      order.stub(:line_items).and_return([build(:line_item, price: 10.0)])
      expect(subject.compute(order).abs).to eql(BigDecimal.new(0))
    end

    it "returns discount for cheapest item" do
      order.stub(:line_items).and_return([
        build(:line_item, price: BigDecimal.new(100.0, 2)),
        build(:line_item, price: BigDecimal.new(200.0, 2))
      ])
      expect(subject.compute(order)).to eql(BigDecimal.new(-30, 2))
    end

    it "handles items with quantity > 1" do
      order.stub(:line_items).and_return([ build(:line_item, price: BigDecimal.new(10.0, 2), quantity: 10) ])
      expect(subject.compute(order)).to eql(BigDecimal.new(-3.0, 2))
    end

    it "returns discount for several items" do
      subject.preferred_items_count = 5
      order.stub(:line_items).and_return([build(:line_item, price: BigDecimal.new(10.0, 2), quantity: 10)])
      expect(subject.compute(order)).to eql(BigDecimal.new(-15.0, 2))
    end
  end
end
