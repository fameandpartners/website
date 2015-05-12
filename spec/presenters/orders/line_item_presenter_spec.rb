require 'spec_helper'

module Orders
  RSpec.describe LineItemPresenter do

    describe 'delegates to LineItem' do

      let(:item) do
        FactoryGirl.build(:line_item,
                          :id       => 300,
                          :price    => 999,
                          :quantity => 3,
        )
      end

      let(:order)         { instance_spy 'Spree::Order' }
      subject(:presenter) { described_class.new(item, order) }

      it('#id')            { expect(subject.id).to eq 300     }
      it('#display_price') { expect(subject.price).to eq 999  }
      it('#quantity')      { expect(subject.quantity).to eq 3 }
    end

    describe '#shipment' do
      it 'exposes properties of @shipment' do
        item       = double 'item'
        shipped    = double 'shipped?'
        shipped_at = double 'shipped_at'
        shipment   = double 'shipment', :line_items => [item], :shipped? => shipped, :shipped_at => shipped_at
        order      = double 'order', :shipments => [shipment]

        presenter  = described_class.new(item, order)

        expect(presenter.shipped_at).to eq shipped_at
        expect(presenter.shipped?).to   eq shipped
      end
    end

    describe '#size' do
      it 'reverts to unknown for missing dress sizes' do
        item      = double 'item', personalization: nil, variant: double(dress_size: nil)
        order     = double 'order', site_version: 'SITE'
        presenter = described_class.new(item, order)
        expect(presenter.country_size).to eq 'SITE-Unknown Size'
      end
    end
  end
end
