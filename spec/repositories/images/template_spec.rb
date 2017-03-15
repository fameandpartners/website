require_relative '../../../app/repositories/images/template'

describe Repositories::Images::Template do
  subject(:template) { described_class.new }

  describe 'defaults' do
    it do
      expect(template).to have_attributes(
        id:       nil,
        position: 0,
        original: 'noimage/product.png',
        large:    'noimage/product.png',
        xlarge:   'noimage/product.png',
        small:    'noimage/product.png'
      )
    end
  end

  describe '#marshal_dump' do
    let(:attributes) { {
      id:       123,
      position: 3,
      original: 'original.png',
      large:    'large.png',
      xlarge:   'xlarge.png',
      small:    'small.png'
    } }
    let(:template) { described_class.new(attributes) }

    it 'returns a hash with object attributes' do
      expect(template.marshal_dump).to eq(attributes)
    end
  end
end
