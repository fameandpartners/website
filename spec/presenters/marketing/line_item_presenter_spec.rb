require 'spec_helper'

describe Marketing::LineItemPresenter, type: :presenter do
  let(:order)     { build_stubbed(:spree_order) }
  let(:presenter) { described_class.new(item, order) }

  describe 'delegates to Spree::LineItem' do
    let(:item) { build(:line_item, id: 300, price: 999, quantity: 3) }

    it('#quantity') { expect(presenter.quantity).to eq(3) }
  end

  describe 'instance methods' do
    let(:product)        { build_stubbed(:spree_product, name: 'Super Dress') }
    let(:master_variant) { build_stubbed(:spree_variant, product: product, sku: 'Master') }
    let(:variant)        { build_stubbed(:spree_variant, product: product, sku: 'ABC') }
    let(:item)           { build_stubbed(:line_item, variant: variant, quantity: 2, price: 101.1) }

    before(:each) { allow(product).to receive(:master).and_return(master_variant) }

    describe '#sku' do
      context 'variant SKU is not blank' do
        it 'returns the line item variant SKU' do
          expect(presenter.sku).to eq('ABC')
        end
      end

      context 'variant SKU is blank' do
        before(:each) { variant.sku = '' }

        it 'returns the product SKU' do
          expect(presenter.sku).to eq('Master')
        end
      end
    end

    describe '#product_name' do
      it 'returns the product name' do
        expect(presenter.product_name).to eq('Super Dress')
      end
    end

    describe '#category_name' do
      describe 'returns the first taxon name of the line item product' do
        context 'product has no taxons' do
          it 'returns nil' do
            expect(presenter.category_name).to be_nil
          end
        end

        context 'product has taxons' do
          let(:long_dresses_taxon)   { build_stubbed(:taxon, name: 'Long Dresses') }
          let(:formal_dresses_taxon) { build_stubbed(:taxon, name: 'Formal Dresses') }

          before(:each) { product.taxons = [long_dresses_taxon, formal_dresses_taxon] }

          it 'returns the first taxon name' do
            expect(presenter.category_name).to eq('Long Dresses')
          end
        end
      end
    end

    describe '#total_amount' do
      it 'returns the total amount of an item' do
        # Quantity * Price
        expect(presenter.total_amount).to eq(202.2)
      end
    end
  end
end
