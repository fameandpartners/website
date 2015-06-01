require 'spec_helper'

describe Spree::Calculator::ProgressivePercents, type: :model do
  let(:order) { build(:spree_order) }
  let(:subject) { Spree::Calculator::ProgressivePercents.new(
    preferred_dresses_nums: '3,5',
    preferred_discount_amounts: '15,20,25'
  )}

  context "#compute" do
    it "returns 15% discount" do
      expect(order).to receive(:amount).and_return(BigDecimal.new(100))
      expect(subject).to receive(:order_items_num).and_return(2)

      expect(subject.compute(order)).to eql(BigDecimal.new(15))
    end

    it "returns 20% discount" do
      expect(order).to receive(:amount).and_return(BigDecimal.new(100))
      expect(subject).to receive(:order_items_num).and_return(4)

      expect(subject.compute(order)).to eql(BigDecimal.new(20))
    end

    it "returns 25% discount" do
      expect(order).to receive(:amount).and_return(BigDecimal.new(100))
      expect(subject).to receive(:order_items_num).and_return(5)

      expect(subject.compute(order)).to eql(BigDecimal.new(25))
    end
  end
end
