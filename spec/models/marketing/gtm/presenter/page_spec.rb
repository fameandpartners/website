require 'spec_helper'

module Marketing
  module Gtm
    module Presenter
      describe Page, type: :presenter do
        let(:type) { 'product' }

        subject(:presenter) { described_class.new(type: type) }

        it_behaves_like 'a Marketing::Gtm::Presenter::Base'

        describe '#body' do
          context 'given a type' do
            it 'returns hash given data' do
              expect(subject.body).to eq({
                                             type:            'product',
                                         })
            end
          end
        end
      end
    end
  end
end
