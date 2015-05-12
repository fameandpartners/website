require 'spec_helper'

describe Products::DetailsResource do
  describe '#product_short_description' do
    let(:resource) { described_class.new(product: product) }

    context 'given a product with a meta description' do
      let(:product) { create(:dress, meta_description: 'My Meta Description') }

      it 'it uses its meta description field' do
        result = resource.send(:product_short_description)
        expect(result).to eq('My Meta Description')
      end
    end

    context 'given a product with a blank meta description' do
      let(:product) { create(:dress, description: '<b>Huge</b>'*50) }

      it 'uses the truncated and sanitized version of the product description' do
        result = resource.send(:product_short_description)
        expect(result).to eq('HugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeH...')
        expect(result.size).to eq(described_class::META_DESCRIPTION_MAX_SIZE)
      end
    end
  end
end