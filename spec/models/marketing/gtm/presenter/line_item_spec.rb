require 'spec_helper'

module Marketing
  module Gtm
    module Presenter
      describe LineItem, type: :presenter do
        let(:taxon) { create(:taxon, name: 'Jeans') }
        let(:product) { build(:dress, id: 123, name: 'Super Dress', sku: 'ProductSKU', taxons: [taxon], description: 'Super Product Description') }
        let(:fabric) { double(:fabric, name: 'FABRICNAME', id: 1) }
        let(:fabric_product) { double(:fabric_product, fabric: fabric) }
        let(:variant) { create(:dress_variant, product: product) }
        let(:line_item) { build(:dress_item, variant: variant, quantity: 3, price: 11.11, fabric_price: 5, id: 1) }

        subject(:presenter) { described_class.new(spree_line_item: line_item) }

        it_behaves_like 'a Marketing::Gtm::Presenter::Base'

        describe '#body' do
          before(:each) do
            allow(line_item).to receive(:fabric).and_return(fabric)
            allow(FabricsProduct).to receive(:find_by_fabric_id_and_product_id).and_return(fabric_product)
          end

          context 'given a spree line item' do
            it 'returns hash line item details' do
              expect(subject.body).to eq({
                category:     'Jeans',
                name:         'Super Dress',
                line_item_id: 1,
                quantity:     3,
                total_amount: 48.33,
                sku:          'ProductSKU~FABRICNAME',
                price:        16.11,
                product_sku:  'ProductSKU',
                description:  'Super Product Description',
                image_url:    "http://localhost/assets/noimage/customdress.png",
                is_curation:  false,
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
