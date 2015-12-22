require 'spec_helper'


module Marketing
  module Gtm
    module Presenter
      describe Variant, type: :presenter do
        let(:variant) { build(:dress_variant, sku: 'ABC123', is_master: true) }

        subject { described_class.new(spree_variant: variant) }

        describe '#body' do
          it 'returns hash with variant info' do
            expect(subject.body).to eq({ sku: 'ABC123' })
          end
        end
      end
    end
  end
end
