require 'spec_helper'

describe Skus::Generator do
  describe '#call' do
    context 'given nil attributes' do
      let(:attributes) { { style_number: nil, size: nil, color_id: nil, height: nil, customization_value_ids: nil } }

      it 'does not raise errors' do
        generator = described_class.new(attributes)
        expect { generator.call }.not_to raise_error
      end
    end

    context 'non BM dress' do
      let(:combinations) {
        [
          {
            attributes: { style_number: 'Something', size: 'US2/AU6', color_id: 123, height: 'Petite', customization_value_ids: [42, 123] },
            expected:   'SOMETHINGUS2AU6C123X42X123HPE'
          },
          {
            attributes: { style_number: 'Single Customization', size: 'US2/AU6', color_id: 123, height: 'Tall', customization_value_ids: [998] },
            expected:   'SINGLECUSTOMIZATIONUS2AU6C123X998HTL'
          },
          {
            attributes: { style_number: 'Lorotinha', size: 'US20/AU26', color_id: '514', height: 'Standard' },
            expected:   'LOROTINHAUS20AU26C514XHSD'
          }
        ]
      }

      it 'generates a SKU with the expected format (described at the EBNF docs)' do
        combinations.each do |combination|
          generator = described_class.new(combination[:attributes])
          expect(generator.call).to eq(combination[:expected])
        end
      end

      context 'product does not have personalizations' do
        let(:attributes) { { style_number: 'WithoutCustomizations', size: 'US4/AU8', color_id: '525' } }

        it 'generates SKUs X marker' do
          generator = described_class.new(attributes)
          expect(generator.call).to eq('WITHOUTCUSTOMIZATIONSUS4AU8C525XHSD')
        end
      end
    end
  end

  context 'when BM dress' do
    let(:combinations) {
        [
          {
            attributes: { style_number: 'FPG1001', size: 'US2/AU6', height: 'length6', customization_value_ids: ['T0', 'B12', 'C4'], fabric: mock_model(Fabric, { name: '102-2020'}) },
            expected:   'FPG1001~102~2020~B12~C4~H6~T0~US2AU6'
          },
          {
            attributes: { style_number: 'FPG1001', size: 'US20/AU26', height: 'length1' },
            expected:   'FPG1001~H1~US20AU26'
          }
        ]
      }

      it 'generates a SKU with the expected format (described at the EBNF docs)' do
        combinations.each do |combination|
          generator = described_class.new(combination[:attributes])
          expect(generator.call).to eq(combination[:expected])
        end
      end

      context 'product does not have personalizations' do
        let(:attributes) { { style_number: 'FPG1001', size: 'US4/AU8' } }

        it 'generates SKUs X marker' do
          generator = described_class.new(attributes)
          expect(generator.call).to eq('FPG1001~US4AU8')
        end
      end
  end
end
