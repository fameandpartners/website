require 'spec_helper'

describe Spree::Product, :type => :model do
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

  describe '#size_chart' do
    it do
      is_expected.to validate_inclusion_of(:size_chart).in_array(%w(2014 2015))
    end

    describe '#new_size_chart?' do
      it 'not by default' do
        product = described_class.new
        expect(product.new_size_chart?).to be_falsey
      end

      it 'when latest' do
        product = described_class.new :size_chart => described_class::SIZE_CHARTS.last
        expect(product.new_size_chart?).to be_truthy
      end
    end
  end
end
