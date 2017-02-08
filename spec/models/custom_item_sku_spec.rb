require 'spec_helper'

# 11th January 2017: SKU Generation is now handled by the `Skus::Generator`. These tests are somehow duplicated

RSpec.describe CustomItemSku do
  let(:custom_colour) { create :product_colour, name: 'pink' }
  let(:custom_size)   { create :product_size, size_template: 3 }
  let(:customization_ids) { [1] }
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
      item.customization_value_ids = customization_ids
      item.product_id              = variant.product.id
      item.height                  = chosen_height
    end
  }

  describe 'custom items' do
    let(:line_item) { build :line_item, variant: variant, personalization: personalization }

    it 'generates a custom SKU' do
      expect(sku).to eq "FB1000US3AU7C#{custom_colour.id}X1HS"
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

    describe 'customizations' do
      describe 'single customization (the default)' do
        let(:customization_ids) { [999] }
        it 'are marked with X and the ID' do
          expect(sku).to include("X999")
        end
      end

      describe 'no customizations (custom colour, size, or height)' do
        let(:customization_ids) { [] }

        it 'are marked with just X' do
          expect(sku).to include("X")
          expect(sku).to end_with "XHS"
        end
      end

      describe 'multiple customizations (legacy edge case)' do
        let(:customization_ids) { [33, 55] }

        it 'are each marked with X and the ID' do
          expect(sku).to include("X33X55")
        end
      end
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

      describe 'transformation' do
        let(:chosen_height) { 'abc' }
        it { expect(sku).to end_with("HA") }
      end
    end

    describe 'fallback on error' do
      before do
        allow(generator).to receive(:style_number).and_raise(StandardError)
      end

      it 'falls back to SKU and custom marker' do
        expect(sku).to eq "#{variant.sku}X"
      end

      it 'still marks the SKU as custom' do
        expect(sku).to end_with('X')
      end

      it 'reports to NewRelic and Sentry' do
        expect(Raven).to receive(:capture_exception).with(StandardError)
        expect(NewRelic::Agent).to receive(:notice_error).with(StandardError, line_item_id: nil)

        generator.call
      end
    end
  end

  describe 'default items' do
    let(:line_item) { build :line_item, variant: variant }

    it 'defaults to the variant SKU' do
      expect(sku).to eq line_item.variant.sku
    end

    it 'wont mark customs with X' do
      expect(sku).to_not include("X")
    end
  end
end
