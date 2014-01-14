require 'spec_helper'

describe Spree::Product do
  context "new product" do
    let(:subject) { Spree::Product.new }

    it "should be on demand" do
      subject.on_demand.should == true
    end
  end
end
