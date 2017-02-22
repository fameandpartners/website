require 'spec_helper'

module Marketing
  module Gtm
    module Presenter
      describe LineItem, type: :presenter do
        let(:taxon) { create(:taxon, name: 'Jeans') }
        let(:product) { build(:dress, id: 123, name: 'Super Dress', sku: 'ProductSKU', taxons: [taxon], description: 'Super Product Description') }
        let(:variant) { create(:dress_variant, product: product) }
        let(:line_item) { build(:dress_item, variant: variant, quantity: 3, price: 11.11) }

        subject(:presenter) { described_class.new(spree_line_item: line_item) }

        it_behaves_like 'a Marketing::Gtm::Presenter::Base'

        describe '#body' do
          before(:each) do
            expect(VariantSku).to receive(:new).with(variant).and_return(-> { 'VariantSKU' })
            expect(CustomItemSku).to receive(:new).with(line_item).and_return(-> { 'LineItemSKU' })
          end

          context 'given a spree line item' do
            it 'returns hash line item details' do
              expect(subject.body).to eq({
                category:     'Jeans',
                name:         'Super Dress',
                quantity:     3,
                total_amount: 33.33,
                sku:          'LineItemSKU',
                variant_sku:  'VariantSKU',
                product_sku:  'ProductSKU',
                description:  'Super Product Description',
                image_url:    'noimage/product.png', # Repositories::LineItemImages responsibility. Default fallback result.
                product_url:  '/dresses/dress-super-dress-123'
              })
            end
          end

          context 'given a base URL' do
            subject(:presenter) { described_class.new(spree_line_item: line_item, base_url: 'https://example.com') }

            it 'renders full product URL' do
              expect(subject.body).to include({ product_url: 'https://example.com/dresses/dress-super-dress-123' })
            end
          end
        end
      end
    end
  end
end
