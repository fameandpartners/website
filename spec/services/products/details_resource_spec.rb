require 'spec_helper'

describe Products::DetailsResource do
  describe 'private methods' do
    let(:resource) { described_class.new(product: product) }

    describe '#get_product_id_from_slug' do
      let(:product) { create(:dress) }

      context 'given a slug with a product name and id' do
        it 'returns the id of the slug' do
          result = resource.send(:get_product_id_from_slug, 'alexa-pink-123')
          expect(result).to eq('123')
        end
      end

      context 'given a slug without an id' do
        it 'returns nil' do
          result = resource.send(:get_product_id_from_slug, 'this-is-not-a-product')
          expect(result).to be_nil
        end
      end
    end
  end
end
