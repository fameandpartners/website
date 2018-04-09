require 'spec_helper'

module Marketing
  module Gtm
    module Presenter
      describe Collection, type: :presenter do
        # Fake Products::CollectionResource data
        let(:first_variant) { build_stubbed(:dress_variant, sku: 'SKU123') }
        let(:second_variant) { build_stubbed(:dress_variant, sku: 'SKU345') }
        let(:super_dress) { build_stubbed(:dress, id: 123, sku: 'SUPERSKU', variants: [first_variant], name: 'Super Dress', price: {amount: 31.30}) }
        let(:jedi_cosplay) { build_stubbed(:dress, id: 456, sku: 'JEDISKU', variants: [second_variant], name: 'Jedi Cosplay', price: {amount: 31.31})  }
        let(:product_collection) { OpenStruct.new(products: [super_dress, jedi_cosplay]) }

        subject(:presenter) { described_class.new(collection_presenter: product_collection) }

        it_behaves_like 'a Marketing::Gtm::Presenter::Base'

        describe '#body' do
          it 'returns a hash with product collection info' do
            expect(subject.body).to eq([
                                         {
                                           sku:  'SUPERSKU',
                                           variant_skus: ['SKU123'],
                                           name: 'Super Dress'
                                         },
                                         {
                                           sku:  'JEDISKU',
                                           variant_skus: ['SKU345'],
                                           name: 'Jedi Cosplay'
                                         },
                                       ])
          end
        end
      end
    end
  end
end
