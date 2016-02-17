require 'spec_helper'

module Marketing
  module Gtm
    module Presenter
      describe Collection, type: :presenter do
        # Fake Products::CollectionResource data
        let(:super_dress) { build_stubbed(:dress, id: 123, sku: 'SUPERSKU', name: 'Super Dress') }
        let(:jedi_cosplay) { build_stubbed(:dress, id: 456, sku: 'JEDISKU', name: 'Jedi Cosplay') }
        let(:product_collection) { OpenStruct.new(products: [super_dress, jedi_cosplay]) }

        subject(:presenter) { described_class.new(collection_presenter: product_collection) }

        it_behaves_like 'a Marketing::Gtm::Presenter::Base'

        describe '#body' do
          it 'returns a hash with product collection info' do
            expect(subject.body).to eq([
                                         {
                                           sku:  'SUPERSKU',
                                           name: 'Super Dress'
                                         },
                                         {
                                           sku:  'JEDISKU',
                                           name: 'Jedi Cosplay'
                                         },
                                       ])
          end
        end
      end
    end
  end
end
