require 'spec_helper'

module Marketing
  module Gtm
    module Presenter
      describe LineItem, type: :presenter do
        let(:taxon) { create(:taxon, name: 'Jeans') }
        let(:product) { build(:dress, id: 123, name: 'Super Dress', sku: 'ProductSKU', taxons: [taxon], description: 'Super Product Description') }
        let(:fabric) { double(:fabric, name: 'FABRICNAME', price_in: 5) }
        let(:variant) { create(:dress_variant, product: product) }
        let(:line_item) { build(:dress_item, variant: variant, quantity: 3, price: 11.11) }

        subject(:presenter) { described_class.new(spree_line_item: line_item) }

        it_behaves_like 'a Marketing::Gtm::Presenter::Base'

        describe '#body' do
          before(:each) do
            allow(line_item).to receive(:fabric).and_return(fabric)
          end

          context 'given a spree line item' do
            it 'returns hash line item details' do
              expect(subject.body).to eq({
                category:     'Jeans',
                name:         'Super Dress',
                quantity:     3,
                total_amount: 48.33,
                sku:          'ProductSKU~FABRICNAME',
                price:        198.37,
                product_sku:  'ProductSKU',
                description:  'Super Product Description',
                image_url:    'noimage/product.png', # Repositories::LineItemImages responsibility. Default fallback result.
                product_path:  '/dresses/dress-super-dress-123',
                product_url:  'http://localhost/dresses/dress-super-dress-123'
              })
            end
          end
        end

        describe '#product_url' do
          context 'given a base URL' do
            let(:presenter) { described_class.new(spree_line_item: line_item, base_url: 'https://example.com') }

            it do
              expect(presenter.body).to include({ product_url: 'https://example.com/dresses/dress-super-dress-123' })
            end
          end

          context 'given the APP_HOST env var' do
            let(:app_host) { ENV.fetch('APP_HOST', 'https://example.com') }

            it do
              expect(presenter.body).to include({ product_url: "#{app_host}/dresses/dress-super-dress-123" })
            end
          end
        end
      end
    end
  end
end
