require 'spec_helper'

describe Spree::Variant, :type => :model do
  context "new product" do
    let(:subject) { Spree::Variant.new }

    it "should be on demand" do
      expect(subject.on_demand).to be true
    end

    it "should have non-zero amount" do
      expect(subject.count_on_hand).to be > 0
    end
  end

  context "fast_delivery" do
    let(:subject) { Spree::Variant.new }

    it "true for existing items on stock" do
      subject.on_demand     = false
      subject.count_on_hand = 5

      expect(subject.fast_delivery?).to be true
    end

    it "false for 0 quantity on stock" do
      subject.on_demand     = false
      subject.count_on_hand = 0

      expect(subject.fast_delivery?).to be false
    end

    it "false if product on demand" do
      subject.on_demand = true
      subject.count_on_hand = 5
      expect(subject.fast_delivery?).to be false
    end
  end
end
