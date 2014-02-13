require 'spec_helper'

describe Spree::Variant do
  context "new product" do
    let(:subject) { Spree::Variant.new }

    it "should be on demand" do
      subject.on_demand.should == true
    end

    it "should have non-zero amount" do
      subject.count_on_hand.should > 0
    end
  end
end
