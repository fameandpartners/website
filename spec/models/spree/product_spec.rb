require 'spec_helper'

describe Spree::Product, :type => :model do
  subject(:product) { FactoryGirl.build :dress }

  describe 'scopes' do
    describe '.jackets' do
      let!(:jacket)  { create(:jacket) }
      let!(:dress)   { create(:dress) }
      let!(:jackets) { create(:taxon, permalink: 'jackets', products: [jacket]) }

      it 'returns all products that belongs to jackets taxon' do
        expect(described_class.jackets).to eq([jacket])
      end
    end
  end

  context "new product" do
    it "should be on demand" do
      expect(subject.on_demand).to be true
    end
  end

  context "fast_delivery" do
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
      it 'by default' do
        product = described_class.new
        expect(product.new_size_chart?).to be_truthy
      end

      it 'when latest' do
        product = described_class.new :size_chart => '2015'
        expect(product.new_size_chart?).to be_truthy
      end
    end
  end

  describe '#active?' do
    subject(:product) do
      build :dress,
            deleted_at:   nil,
            hidden:       false,
            available_on: Date.yesterday
    end

    it { is_expected.to be_active }

    context 'deleted' do
      before { product.deleted_at = Time.now }
      it     { is_expected.to_not be_active }
    end

    describe 'future items' do
      before { product.available_on = 2.days.from_now }
      it     { is_expected.to_not be_active }
    end

    describe 'hidden' do
      before { product.hidden = true }
      it     { is_expected.to_not be_active }
    end
  end

  describe '#color_customization' do
    yes_values = %w(Y y yes true TRUE T t 1)
    no_values  = %w(N NO no n whatever anything)

    let(:product) do
      FactoryGirl.build(:dress).tap { |product|
        allow(product).to receive(:property).with('color_customization').and_return(a_value)
      }
    end

    subject(:color_customization) { product.color_customization }

    describe 'allows color_customization' do
      yes_values.map do |a_value|
        context "when: #{a_value}" do
          let(:a_value) { a_value }
          it { is_expected.to be_truthy }
        end
      end
    end

    describe 'does not allow color_customization' do
      no_values.map do |a_value|
        context "when: #{a_value}" do
          let(:a_value) { a_value }
          it { is_expected.to be_falsey }
        end
      end
    end
  end
end
