require 'spec_helper'

describe Spree::Calculator::PersonalizationDiscount, type: :model do
  def build_personalization_double(size, color, customization)
    double('personalization',
           size_cost: BigDecimal.new(size),
           color_cost: BigDecimal.new(color),
           customizations_cost: BigDecimal.new(customization)
    )
  end

  context "#compute" do
    let(:subject) { Spree::Calculator::PersonalizationDiscount.new(
      preferred_custom_size_discount: 20,
      preferred_custom_color_discount: 50,
      preferred_customizations_discount: 80
    )}
    let(:order) { build(:spree_order) }

    it "returns 0 for empty order" do
      expect(subject.compute(order)).to eql(BigDecimal.new(0))
    end

    it "returns 0 for order without personalizations" do
      expect(subject).to receive(:order_personalizations).with(order).and_return([])
      expect(subject.compute(order)).to eql(BigDecimal.new(0))
    end

    it "returns discounted size" do
      personalization = build_personalization_double(10, 0, 0)
      expect(subject).to receive(:order_personalizations).with(order).and_return([personalization])
      expect(subject.compute(order)).to eql(-BigDecimal.new(2))
    end

    it "returns discounted color" do
      personalization = build_personalization_double(0, '15', 0)
      expect(subject).to receive(:order_personalizations).with(order).and_return([personalization])
      expect(subject.compute(order)).to eql(-BigDecimal.new('7.5'))
    end

    it "returns discounted customizations" do
      personalization = build_personalization_double(0, 0, '29.9')
      expect(subject).to receive(:order_personalizations).with(order).and_return([personalization])
      expect(subject.compute(order)).to eql(-BigDecimal.new('23.92'))
    end

    it "returns discount" do
      personalization = build_personalization_double('9.9', '19.9', '29.9')
      expect(subject).to receive(:order_personalizations).with(order).and_return([personalization])
      expect(subject.compute(order)).to eql(BigDecimal.new('-35.85'))
    end
  end
end
