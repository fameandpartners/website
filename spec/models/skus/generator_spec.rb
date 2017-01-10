require 'spec_helper'

describe Skus::Generator do
  describe '#call' do
    describe 'given product and customizations info to the class' do
      let(:combinations) {
        [
          { attributes: { style_number: 'Something', size: 'US2/AU6', color_id: 123, height: 'Petite', customization_value_ids: [42, 123] }, expected: 'SOMETHINGUS2AU6C123X42X123HP' },
          { attributes: { style_number: 'Lorotinha', size: 'US20/AU26', color_id: '514', height: 'Standard' }, expected: 'LOROTINHAUS20AU26C514XHS' },
          { attributes: { style_number: '', size: '', color_id: '', height: '' }, expected: 'CXH' }
        ]
      }

      it 'generates a SKU with the expected format (described at the EBNF docs)' do
        combinations.each do |combination|
          generator = described_class.new(combination[:attributes])
          expect(generator.call).to eq(combination[:expected])
        end
      end
    end
  end
end
