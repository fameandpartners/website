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
              master_id:         456,
              sku:               'ABC123',
              name:              'Super Dress',
              short_description: 'Super Dress Short Description',
              description:       'Super Dress Long Description',
              permalink:         'super-dress-permalink',
              is_active:         true,
              default_image:     fake_image,
              price:             product_price,
              discount:          discount,
              taxons:            [taxon_presenter],
              # Not used by GTM. Yet.
              # recommended_products: [],
              # related_outerwear:    [],
              # moodboard:            {},
              color_name:        'Red',
              available_options: fake_available_options,
              fabric:            'Product Fabric',
              fit:               'Eloise wears a size AU10/US6',
              size:              'Top length: 40.5cm Height & Hemline: 50cm',
              style_notes:       'Product Style Notes',
              size_chart:        '2015',
              fast_making:       true,
          )
        end

        subject(:presenter) { described_class.new(product_presenter: product_presenter) }

        it_behaves_like 'a Marketing::Gtm::Presenter::Base'

        describe '#body' do
          it 'returns hash with product info' do
            expect(subject.body).to eq({
              brand:             'Fame & Partners',
              categories:        ['jeans'],
              colors:            ['Ivory'],
              currency:          'AUD',
              description:       'Super Dress Long Description',
              discountPercent:   30,
              expressMaking:     true,
              image:             { original: 'https://d1sd72h9dq237j.cloudfront.net/original.png', xlarge: 'https://d1sd72h9dq237j.cloudfront.net/xlarge.png', large: 'https://d1sd72h9dq237j.cloudfront.net/large.png', small: 'https://d1sd72h9dq237j.cloudfront.net/small.png' },
              id:                123,
              name:              'Super Dress',
              price:             12.34,
              priceWithDiscount: 8.64,
              selectedColor:     'Red',
              sizes:             ['US 2'],
              sku:               'ABC123',
              type:              'dresses',
            })
          end
        end

      end
    end
  end
end
