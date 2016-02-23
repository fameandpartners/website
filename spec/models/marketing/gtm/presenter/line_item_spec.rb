require 'spec_helper'

module Marketing
  module Gtm
    module Presenter
      describe LineItem, type: :presenter do
        let(:taxon)     { create(:taxon, name: 'Jeans') }
        let(:product)   { create(:dress, name: 'Super Dress', sku: 'ProductSKU', taxons: [taxon]) }
        let(:variant)   { create(:dress_variant, product: product) }
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
                                             sku:          'LineItemSKU',
                                             variant_sku:  'VariantSKU',
                                             product_sku:  'ProductSKU',
                                             total_amount: 33.33
                                         })
            end
          end
        end
      end
    end
  end
end
