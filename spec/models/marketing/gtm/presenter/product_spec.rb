require 'spec_helper'


module Marketing
  module Gtm
    module Presenter
      describe Product, type: :presenter do
        let(:product_price) { build_stubbed(:price, amount: 12.34, currency: 'AUD') }
        let(:product) { build_stubbed(:spree_product, name: 'Super Dress') }
        let(:taxon) { build_stubbed(:taxon, name: 'Jeans') }

        # Fake product data. Not going to reinvent resources, services and OpenStructs inside OpenStructs here
        let(:fake_image) do
          OpenStruct.new(
              position: 1,
              original: 'https://d1sd72h9dq237j.cloudfront.net/original.png',
              large:    'https://d1sd72h9dq237j.cloudfront.net/large.png',
              xlarge:   'https://d1sd72h9dq237j.cloudfront.net/xlarge.png',
              small:    'https://d1sd72h9dq237j.cloudfront.net/small.png',
              color:    'pink',
              color_id: 29
          )
        end

        let(:fake_available_options) do
          OpenStruct.new(
              colors: OpenStruct.new(
                  default: [
                               OpenStruct.new(
                                   name:         'Ivory',
                                   presentation: 'Ivory'
                               )
                           ],
                  extra:   []
              ),
              sizes:  OpenStruct.new(
                  default: [
                               OpenStruct.new(presentation: 'US 2')
                           ],
                  extra:   []
              )
          )
        end

        let(:discount) { OpenStruct.new(amount: 30, size: 30) }
        let(:product_images) { [fake_image] }

        let(:taxon_presenter) { Taxons::Presenter.new(spree_taxon: taxon) }
        let(:product_presenter) do
          Products::Presenter.new(
              id:                123,
              sku:               'ABC123',
              name:              'Super Dress',
              price:             product_price,
          )
        end

        subject(:presenter) { described_class.new(product_presenter: product_presenter) }

        it_behaves_like 'a Marketing::Gtm::Presenter::Base'

        describe '#body' do
          it 'returns hash with product info' do
            expect(subject.body).to eq({
              id:                123,
              name:              'Super Dress',
              price:             12.34,
              sku:               'ABC123',
              type:              'dresses',
            })
          end
        end

      end
    end
  end
end
