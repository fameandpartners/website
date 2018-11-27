require 'spec_helper'

describe Spree::Product, :type => :model do
  subject(:product) { build(:dress) }

  it { is_expected.to have_one(:celebrity_inspiration).with_foreign_key(:spree_product_id).class_name('CelebrityInspiration').dependent(:destroy) }
  it { is_expected.to have_one(:style_profile).with_foreign_key(:product_id).class_name('ProductStyleProfile').dependent(:destroy) }
  it { is_expected.to have_many(:customisation_values).order('customisation_values.position ASC') }
  it { is_expected.to have_many(:product_color_values).dependent(:destroy) }

  it { is_expected.to have_many(:inspirations).with_foreign_key(:spree_product_id) }
  it { is_expected.to have_many(:accessories).with_foreign_key(:spree_product_id).class_name('ProductAccessory') }

  it { is_expected.to have_many(:making_options).with_foreign_key(:product_id).class_name('ProductMakingOption') }

  it { is_expected.to belong_to(:factory) }
  it { is_expected.to belong_to(:fabric_card).inverse_of(:spree_products) }

  it { is_expected.to have_and_belong_to_many(:related_outerwear).with_foreign_key(:product_id).class_name('Spree::Product') }

  describe 'scopes' do
    describe '.outerwear' do
      let!(:outerwear)          { create(:spree_product) }
      let!(:dress)              { create(:spree_product) }
      let!(:outerwear_taxonomy) { create(:taxonomy, :outerwear) }

      before(:each) { outerwear_taxonomy.root.products = [outerwear] }

      it 'returns all products that belongs to outerwear taxonomy' do
        expect(described_class.outerwear).to eq([outerwear])
      end
    end
  end

  context "new product" do
    it "should be on demand" do
      expect(subject.on_demand).to be true
    end
  end

  describe '#size_chart' do
    it do
      is_expected.to validate_inclusion_of(:size_chart).in_array(%w(2014 2015 2016 2016_v2))
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

  describe 'set_default_values' do
    it 'sets latest size_chart' do
      subject.send(:set_default_values)

      expect(subject.size_chart).to eq(SizeChart::CHARTS.keys.last)
    end
  end
end
