require 'spec_helper'

RSpec.describe CustomItemSku do
  let(:custom_colour) { create :product_colour, name: 'pink' }
  let(:custom_size)   { create :product_size, size_template: 3 }
  let(:chosen_height) { 'standard' }
  let(:style_number)  { 'FB1000' }
  let(:dress)         { create :dress_with_magenta_size_10, sku: style_number }
  let(:master)        { dress.master }
  let(:variant)       { dress.variants.first }

  let(:generator)     { described_class.new(line_item) }
  let(:sku)           { generator.call }

  let(:personalization) {
    LineItemPersonalization.new.tap do |item|
      item.size_id                 = custom_size.id
      item.color_id                = custom_colour.id
      item.customization_value_ids = [1]
      item.product_id              = variant.product.id
      item.height                  = chosen_height
    end
  }

  describe 'custom items' do
    let(:line_item) { build :line_item, variant: variant, personalization: personalization }

    it 'generates a custom SKU' do
      expect(sku).to eq "FB1000US3AU7C#{custom_colour.id}XHS"
    end

    it 'includes the style number' do
      expect(sku).to include(style_number)
    end

    it "includes the custom size name, without separating '/'" do
      expect(sku).to include("US3AU7")
    end

    it 'includes the custom colour id' do
      expect(sku).to include("C#{custom_colour.id}")
    end

    it 'marks customs with X' do
      expect(sku).to include("X")
    end

    describe '#height' do
      context 'standard' do
        let(:chosen_height) { 'standard' }
        it { expect(sku).to end_with("HS") }
      end

      context 'petite' do
        let(:chosen_height) { 'petite' }
        it { expect(sku).to end_with("HP") }
      end

      context 'tall' do
        let(:chosen_height) { 'tall' }
        it { expect(sku).to end_with("HT") }
      end
    end
  end

  describe 'default items' do
    let(:line_item) { build :line_item, variant: variant }

    it 'defaults to the variant SKU' do
      expect(sku).to eq line_item.variant.sku
    end

    it 'wont marks customs with trailing X' do
      expect(sku).to_not end_with("X")
    end
  end
end
