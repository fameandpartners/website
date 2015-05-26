require 'spec_helper'

describe Products::DetailsResource do
  describe '#product_short_description' do
    context 'given a product with a meta description' do
      let(:product)  { create(:dress, meta_description: 'My Meta Description') }
      let(:resource) { described_class.new(id: product.id, name: product.name) }

      it 'it uses its meta description field' do
        result = resource.send(:product_short_description)
        expect(result).to eq('My Meta Description')
      end
    end

    context 'given a product with a blank meta description' do
      let(:product)  { create(:dress, description: '<b>Huge</b>'*50) }
      let(:resource) { described_class.new(id: product.id, name: product.name) }

      it 'uses the truncated and sanitized version of the product description' do
        result = resource.send(:product_short_description)
        expect(result).to eq('HugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeHugeH...')
        expect(result.size).to eq(described_class::META_DESCRIPTION_MAX_SIZE)
      end
    end
  end

  describe 'private methods' do
    let(:resource) { described_class.new }

    describe '#find_product!' do
      let!(:product) { create(:dress, id: 101, name: 'Super red Naomi') }

      context "given a product id and parameterized name" do
        it 'finds product with name-id combination' do
          result = resource.send(:find_product!, 101, 'super-red-naomi')
          expect(result).to eq(product)
        end

        it 'does not find product with invalid name-id combination' do
          expect { resource.send(:find_product!, 101, 'blue-dress') }.to raise_error(Errors::ProductNotFound)
        end
      end
    end
  end
end