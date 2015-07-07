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
        shipment   = double 'shipment',
                            :line_items => [item],
                            :shipped?   => 'am_shipped?',
                            :shipped_at => 'shipped_yesterday',
                            :tracking   => 'tracking_44'
        order      = double 'order', :shipments => [shipment]
        presenter  = described_class.new(item, order)

        expect(presenter.shipped_at).to      eq 'shipped_yesterday'
        expect(presenter.shipped?).to        eq 'am_shipped?'
        expect(presenter.tracking_number).to eq 'tracking_44'
      end

      context 'when missing' do
        it 'provides safe null values' do
          item       = double 'item'
          order      = double 'order', :shipments => []
          presenter  = described_class.new(item, order)

          expect(presenter.shipped_at).to      be_nil
          expect(presenter.shipped?).to        be_falsey
          expect(presenter.tracking_number).to eq 'NoShipment'
        end
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

    describe '#make_size' do
      let(:size)      { double(:size, name: '8')}
      let(:item)      { double 'item', personalization: nil, variant: double(:dress_size => size) }
      let(:order)     { double 'order', site_version: site_version }
      let(:presenter) { described_class.new(item, order) }

      context 'us' do
        let(:site_version) { 'us' }
        it 'maps to correct au size' do
          expect(presenter.make_size).to eq 'au-12'
        end
      end

      context 'au' do
        let(:site_version) { 'au' }
        it 'maps to correct au size' do
          expect(presenter.make_size).to eq 'au-8'
        end
      end
    end

    describe 'returns' do
      let(:item)          { double(Spree::LineItem) }
      let(:order)         { double(Spree::Order, :return_requested? => true) }
      let(:return_item)   { ReturnRequestItem.new(:action => 'return', :reason_category => 'blah', :reason => 'vtha') }
      subject(:presenter) { described_class.new(item, order) }

      before do
        allow(presenter).to receive(:return_item).and_return(return_item)
      end

      it 'has correct action' do
        expect(presenter.return_action).to eq return_item.action
      end

      it 'has correct action' do
        expect(presenter.return_details).to eq '1 x blah - vtha'
      end

    end

    describe '#fabrication_status' do
      let(:item)  { FactoryGirl.build(:line_item, fabrication: fabrication) }
      let(:order) { FactoryGirl.build(:complete_order) }
      subject     { described_class.new(item, order).fabrication_status }

      context 'delegates state to fabrication' do
        let(:fabrication) { Fabrication.new.tap { |f| f.state = :some_state } }

        it do
          is_expected.to eq :some_state
        end
      end

      context 'fallback' do
        let(:fabrication) { nil }
        it do
          is_expected.to eq :processing
        end
      end
    end
  end
end
