require 'spec_helper'

module Marketing
  module Gtm
    module Presenter
      describe Collection, type: :presenter do
        # Fake Products::CollectionResource data
        let(:super_dress)        { build_stubbed(:dress, id: 123, name: 'Super Dress') }
        let(:jedi_cosplay)       { build_stubbed(:dress, id: 456, name: 'Jedi Cosplay') }
        let(:product_collection) { OpenStruct.new(products: [super_dress, jedi_cosplay]) }

        subject(:presenter) { described_class.new(product_collection: product_collection) }

        it_behaves_like 'a Marketing::Gtm::Presenter::Base'

        describe '#body' do
          it 'returns a hash with product collection info' do
            expect(subject.body).to eq({ not_used_yet: true })
            # expect(subject.body).to eq([
            #                                {
            #                                    id:   123,
            #                                    name: 'Super Dress'
            #                                },
            #                                {
            #                                    id:   456,
            #                                    name: 'Jedi Cosplay'
            #                                },
            #                            ])
          end
        end
      end
    end
  end
end
