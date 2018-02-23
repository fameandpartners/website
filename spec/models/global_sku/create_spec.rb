require 'spec_helper'

describe GlobalSku::Create do
  let(:creator) {
    described_class.new(
      style_number: 'ABC123',
      product_name: 'Bianca Dress',
      size:         'US0/AU4',
      color_name:   'Magma Red',
      fabric_name:  'Invalid Fabric', 
      height:       'Petite'
    )
  }

  describe 'validations' do
    include_context 'dress with colors and sizes'

    describe 'when a GlobalSKU already exists' do
      before(:each) { GlobalSku.create(sku: creator.generate_sku) }

      it do
        expect(creator).not_to be_valid
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
          fabric_name:  'Invalid Fabric', 
          height:       'Humongous!'
        )
      }

      it do
        expect(creator).not_to be_valid
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
          fabric_name:  'Invalid Fabric',
          height:       'Invalid Height'
        )
      }

      it { expect(creator.call).to eq(nil) }
    end

    describe 'create a Global SKU given product attributes' do
      let(:generated_sku) { creator.generate_sku }

      context 'without customizations' do
        it do
          expect(creator.call).to have_attributes(
            sku:                generated_sku,
            style_number:       'ABC123',
            product_name:       'Bianca Dress',
            size:               'US0/AU4',
            color_id:           color_red.id,
            color_name:         'magma-red',
            customisation_id:   nil,
            customisation_name: nil,
            height_value:       'petite',
            product_id:         dress.id,
            data:               { 'extended-style-number' => 'ABC123' },
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
            fabric_name:  'Invalid Fabric',
            customizations: JSON.parse([customization_fabric, customization_fit].to_json)
          )
        }

        it do
          expect(creator.call).to have_attributes(
            sku:                generated_sku,
            style_number:       'ABC123',
            product_name:       'Bianca Dress',
            size:               'US0/AU4',
            color_id:           color_red.id,
            color_name:         'magma-red',
            customisation_id:   '123;456',
            customisation_name: 'fabric;fit',
            height_value:       'petite',
            product_id:         dress.id,
            data:               { 'extended-style-number' => 'ABC123-fabric-fit' }
          )
        end
      end
    end
  end

  describe '#generate_sku' do
    include_context 'dress with colors and sizes'

    describe 'calls SKU generator with proper arguments' do
      context 'without customizations' do
        it do
          expect(Skus::Generator).to receive(:new).with(
            style_number:            'ABC123',
            size:                    'US0/AU4',
            color_id:                color_red.id,
            height:                  'petite',
            customization_value_ids: []
          ).and_call_original

          creator.generate_sku
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
            fabric_name:  'Invalid Fabric',
            customizations: JSON.parse([customization_fabric, customization_fit].to_json)
          )
        }

        it do
          expect(Skus::Generator).to receive(:new).with(
            style_number:            'ABC123',
            size:                    'US0/AU4',
            color_id:                color_red.id,
            height:                  'petite',
            customization_value_ids: [customization_fabric.id, customization_fit.id]
          ).and_call_original

          creator.generate_sku
        end
      end
    end
  end
end
