require 'spec_helper'

describe Spree::Product do
  context "new product" do
    let(:subject) { Spree::Product.new }

    it "should be on demand" do
      expect(subject.on_demand).to be true
    end
  end

  context "fast_delivery" do
    let(:subject) { Spree::Product.new }

    it "false if item has no variants" do
      allow(subject).to receive(:variants) { Array.new }
      expect(subject.fast_delivery).to be false
    end

    it "false if no variants with fast delivery" do
      allow(subject).to receive(:variants) { 
        [ double('item with slow delivery', :fast_delivery => false)]
      }
      expect(subject.fast_delivery).to be false
    end

    it "true if exists variant with fast delivery" do
      allow(subject).to receive(:variants) { 
        [ double('item with fast delivery', :fast_delivery => true )]
      }

      expect(subject.fast_delivery).to be true
    end
  end
end
