require 'spec_helper'

describe GlobalSku::Create do
  let(:creator) {
    described_class.new(
      style_number: 'ABC123',
      product_name: 'Bianca Dress',
      size:         'US0/AU4',
      color_name:   'Magma Red',
      height:       'Petite'
    )
  }

  describe 'validations' do
    include_context 'dress with colors and sizes'

    describe 'when a GlobalSKU already exists' do
      before(:each) { GlobalSku.create(sku: creator.generate_sku) }

      it do
        creator.valid?
        expect(creator.errors.messages).to include(style_number: ['has already been taken'])
      end
    end

    describe 'height, color and size do not belong to existent collections' do
      let(:creator) {
        described_class.new(
          style_number: 'ABC123',
          product_name: 'Bianca Dress',
          size:         'US123/AU456',
          color_name:   'Shiny Bright Gold',
          height:       'Humongous!'
        )
      }

      it do
        creator.valid?
        expect(creator.errors.messages).to include({
          height:     ['is not included in the list'],
          color_name: ['is not included in the list'],
          size:       ['is not included in the list']
        })
      end
    end
  end

  describe '#call' do
    include_context 'dress with colors and sizes'

    context 'invalid product' do
      let(:creator) {
        described_class.new(
          style_number: 'ABC123',
          product_name: 'Bianca Dress',
          size:         'Invalid Size',
          color_name:   'Invalid Color',
          height:       'Invalid Height'
        )
      }

      it { expect(creator.call).to eq(nil) }
    end

    describe 'create a Global SKU given product attributes' do
      let(:global_sku) { creator.call }
      let(:generated_sku) { creator.generate_sku }

      context 'without customizations' do
        it do
          expect(global_sku).to have_attributes(
            sku:                generated_sku,
            style_number:       'ABC123',
            product_name:       'Bianca Dress',
            size:               'US0/AU4',
            color_id:           color_red.id,
            color_name:         'magma-red',
            customisation_id:   nil,
            customisation_name: nil,
            height_value:       'petite',
            data:               nil,
            product_id:         dress.id
          )
        end
      end

      context 'with customizations' do
        let(:customization_fabric) { FactoryGirl.build(:customisation_value, id: 123, name: 'fabric') }
        let(:customization_fit) { FactoryGirl.build(:customisation_value, id: 456, name: 'fit') }
        let(:creator) {
          described_class.new(
            style_number: 'ABC123',
            product_name: 'Bianca Dress',
            size:         'US0/AU4',
            color_name:   'Magma Red',
            height:       'Petite',
            customizations: [customization_fabric, customization_fit]
          )
        }

        it do
          expect(global_sku).to have_attributes(
            sku:                generated_sku,
            style_number:       'ABC123',
            product_name:       'Bianca Dress',
            size:               'US0/AU4',
            color_id:           color_red.id,
            color_name:         'magma-red',
            customisation_id:   '123;456',
            customisation_name: 'fabric;fit',
            height_value:       'petite',
            data:               nil,
            product_id:         dress.id
          )
        end
      end
    end
  end
end
