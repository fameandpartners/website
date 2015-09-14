require 'spec_helper'

describe Products::DetailsResource do
  describe 'private methods' do
    let(:resource) { described_class.new(product: product) }

    describe '#product_short_description' do
      context 'given a product with a meta description' do
        let(:product) { create(:dress, meta_description: 'My Meta Description') }

        it 'uses its meta description field' do
          result = resource.send(:product_short_description)
          expect(result).to eq('My Meta Description')
        end
      end

      context 'given a product with a blank meta description' do
        let(:product) { create(:dress, description: '<b>Description</b>') }

        it 'uses its description field' do
          result = resource.send(:product_short_description)
          expect(result).to eq('<b>Description</b>')
        end
      end
    end

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
