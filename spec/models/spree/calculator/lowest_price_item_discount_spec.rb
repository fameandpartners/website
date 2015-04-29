require 'spec_helper'

describe Spree::Calculator::LowestPriceItemDiscount, type: :model do
  context "compute" do
    let(:subject) { Spree::Calculator::LowestPriceItemDiscount.new(
      preferred_discount: 30, preferred_items_count: 1)
    }
    let(:order) { build(:spree_order) }

    it "returns 0 for empty cart" do
      expect(subject.compute(order).abs).to eq(0)
    end

    it "returns 0 for cart with single item" do
      order.stub(:line_items).and_return([build(:line_item, price: 10.0)])
      expect(subject.compute(order).abs).to eq(0)
    end

    it "returns discount for cheapest item" do
      order.stub(:line_items).and_return([
        build(:line_item, price: 100.0),
        build(:line_item, price: 200.0)
      ])
      expect(subject.compute(order)).to eq(-30.0)
    end

    it "handles items with quantity > 1" do
      order.stub(:line_items).and_return([ build(:line_item, price: 10.0, quantity: 10) ])
      expect(subject.compute(order)).to eq(-3.0)
    end

    it "returns discount for several items" do
      subject.preferred_items_count = 5
      order.stub(:line_items).and_return([build(:line_item, price: 10.0, quantity: 10)])
      expect(subject.compute(order)).to eq(-15.0)
    end
  end
end
