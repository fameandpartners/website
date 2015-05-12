require_relative '../../../lib/importers/file_importer'
require_relative '../../../lib/importers/sku_generation'


module Importers
  module SkuGeneration

    RSpec.describe Importer do

    end


    RSpec.describe BaseSize do
      let(:basis) { 'AU' }

      describe '.base_set' do
        it 'generates 12 default sizes' do
          expect(described_class.size_set.count).to eq 12
        end
      end

      describe '#sku_component' do
        [10, 12, 14, 16, 18, 20, 22, 24, 26].map do |size|
          it do
            expect(described_class.new(size).sku_component).to eq "#{size}#{basis}"
          end
        end

        describe 'pads single digit integers' do
          {'04' => 4, '06' => 6, '08' => 8}.map do |formatted_for_sku, size|
            it do
              expect(described_class.new(size.to_i).sku_component).to eq "#{formatted_for_sku}#{basis}"
            end
          end
        end
      end
    end

    RSpec.describe FabricCardColourTemplate do
      describe '#sku_compenent pads to 3 digits' do
        it 'single digits' do
          expect(described_class.new(4, '_').sku_component).to eq "004"
        end

        it 'pads to 3 digits' do
          expect(described_class.new(11, '_').sku_component).to eq "011"
        end

        it 'pads to 3 digits' do
          expect(described_class.new(999, '_').sku_component).to eq "999"
        end
      end
    end

    RSpec.describe ProductTemplate do
      it 'can generate a single sku' do
        fabric_card = FabricCard.new('FabricCardName', 'FabricCardAbbrev')
        colour1 = FabricCardColour.new(99, 'ColourName')
        fabric_card.colours = [colour1]
        size_four = BaseSize.new(4)
        sizes = [size_four]

        sku_template = ProductTemplate.new('StyleNumber', "StyleName")
        sku_template.fabric_card = fabric_card
        sku_template.base_sizes = sizes

        expect(sku_template.final_skus).to eq ['StyleNumberFabricCardAbbrev09904AU']
      end

      it 'uses all the bits' do
        fabric_card = FabricCard.new('CoolFabric', 'CFAB')
        colour1 = FabricCardColour.new(7, '7Up')
        colour2 = FabricCardColour.new(42, 'Meaning')
        colour3 = FabricCardColour.new(350, 'TreeFiddy')
        fabric_card.colours = [colour1, colour2, colour3]
        size_four = BaseSize.new(4)
        size_twentysix = BaseSize.new(26)
        sizes = [size_four, size_twentysix]

        sku_template = ProductTemplate.new('SD888', "SlinkyDress")
        sku_template.fabric_card = fabric_card
        sku_template.base_sizes = sizes

        expect(sku_template.final_skus).to eq %w[
          SD888CFAB00704AU
          SD888CFAB00726AU
          SD888CFAB04204AU
          SD888CFAB04226AU
          SD888CFAB35004AU
          SD888CFAB35026AU
        ]
      end
    end
  end
end
