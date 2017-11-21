require 'spec_helper'
require 'pry-byebug'

# 11th January 2017: SKU Generation is now handled by the `Skus::Generator`. These tests are somehow duplicated

RSpec.describe CustomItemSku do
  let(:custom_colour) { create :product_colour, name: 'pink' }
  let(:custom_size)   { create :product_size, size_template: 3 }
  let(:customisation_value) { create :customisation_value}
  let(:customization_ids) { [customisation_value.id] }
  let(:chosen_height) { 'standard' }
  let(:style_number)  { 'FB1000' }
  
  let(:dress)         { create :dress_with_magenta_size_10, sku: style_number, customisation_value_ids: customization_ids }
  let(:master)        { dress.master }
  let(:variant)       { dress.variants.first }
  #let(:product)       { variant.product}

  let(:generator)     { CustomItemSku.new(line_item) }
  let(:sku)           { generator.call }
  let(:line_item) { build :line_item, variant: variant, customizations: [customisation_value].to_json }

  let(:personalization) {
    LineItemPersonalization.new.tap do |item|
      item.size_id                 = custom_size.id
      item.color_id                = custom_colour.id
      item.customization_value_ids = customization_ids
      item.product_id              = variant.product.id
      item.height                  = chosen_height
      item.line_item               = line_item
    end
  }


  describe 'custom items' do
   
    it 'generates a custom SKU' do
      line_item.personalization = personalization
      generator.call
      expect(sku).to eq "FB1000US3AU7C#{custom_colour.id}X#{customisation_value.id.to_s}HSD"
    end

    it 'includes the style number' do
      line_item.personalization = personalization
      expect(sku).to include(style_number)
    end

    it "includes the custom size name, without separating '/'" do
      line_item.personalization = personalization
      expect(sku).to include("US3AU7")
    end

    it 'includes the custom colour id' do
      line_item.personalization = personalization
      expect(sku).to include("C#{custom_colour.id}")
    end

   describe 'customizations' do
      describe 'single customization (the default)' do
        let(:customisation_value) {create :customisation_value, id: 999}

        let(:customization_ids) { [customisation_value.id] }
        it 'are marked with X and the ID' do
          line_item.personalization = personalization
          expect(sku).to include("X999")
        end
      end

      describe 'no customizations (custom colour, size, or height)' do
        let(:customization_ids) { [] }

        it 'are marked with just X' do
          line_item.personalization = personalization
          line_item.customizations ='[]'
          expect(sku).to include("X")
          expect(sku).to end_with "XHSD"
        end
      end

      describe 'multiple customizations (legacy edge case)' do
        let(:customisation_value) {create :customisation_value}
        let(:customisation_value2) {create :customisation_value}
        let(:customization_ids) { [customisation_value.id, customisation_value2.id] }

        it 'are each marked with X and the ID' do
          line_item.personalization = personalization
          line_item.customizations = [customisation_value, customisation_value2].to_json 
          expect(sku).to include("X#{customisation_value.id.to_s}X#{customisation_value2.id.to_s}")
        end
      end
    end

    describe '#height' do
      context 'standard' do
        let(:chosen_height) { 'standard' }
        it do
          line_item.personalization = personalization
          expect(sku).to end_with("HSD") 
        end
      end

      context 'petite' do
        let(:chosen_height) { 'petite' }
        it do
         line_item.personalization = personalization
         expect(sku).to end_with("HPE") 
        end
      end

      context 'tall' do
        let(:chosen_height) { 'tall' }
        it do
         line_item.personalization = personalization
         expect(sku).to end_with("HTL") 
        end
      end

    end

    describe 'fallback on error' do
      before do
        allow(generator).to receive(:style_number).and_raise(StandardError)
      end

      it 'falls back to SKU and custom marker' do
        line_item.personalization = personalization
        expect(sku).to eq "#{variant.sku}X"
      end

      it 'still marks the SKU as custom' do
        line_item.personalization = personalization
        expect(sku).to end_with('X')
      end

      it 'reports to NewRelic and Sentry' do
        line_item.personalization = personalization
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
