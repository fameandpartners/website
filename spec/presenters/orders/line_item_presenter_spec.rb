require 'spec_helper'

module Orders
  RSpec.describe LineItemPresenter do
    let(:item) do
      FactoryGirl.build(
          :line_item,
          id:       300,
          price:    999,
          quantity: 3,
          currency: 'USD'
      )
    end

    let(:order)         { instance_spy 'Spree::Order' }
    subject(:presenter) { described_class.new(item, order) }

    describe 'delegates to LineItem' do
      it('#id')            { expect(subject.id).to eq 300 }
      it('#display_price') { expect(subject.price).to eq 999 }
      it('#quantity')      { expect(subject.quantity).to eq 3 }
      it('#currency')      { expect(subject.currency).to eq 'USD' }
    end

    describe '#shipment' do
      let(:shipment) do
        double('shipment',
               shipped?:   'am_shipped?',
               shipped_at: 'shipped_yesterday',
               tracking:   'tracking_44'
        )
      end
      let(:item)          { double('item', shipment: shipment) }
      let(:order)         { double('order', shipments: [shipment]) }

      subject(:presenter) { described_class.new(item, order) }

      it 'exposes properties of @shipment' do
        expect(presenter.shipped_at).to eq 'shipped_yesterday'
        expect(presenter.shipped?).to eq 'am_shipped?'
        expect(presenter.tracking_number).to eq 'tracking_44'
      end

      context 'when missing' do
        let(:item)          { double('item', shipment: nil) }
        let(:order)         { double('order', shipments: []) }

        subject(:presenter) { described_class.new(item, order) }

        it 'provides safe null values' do
          expect(presenter.shipped_at).to be_nil
          expect(presenter.shipped?).to be_falsey
          expect(presenter.tracking_number).to eq 'NoShipment'
        end
      end
    end

    # Normally I'm not a fan of digging into message chains, but the sort of deep
    # nested fall-throughs that the presenter code uses to get around the fragile
    # data model make this a much clearer way of testing, instead of lots of manually
    # created intermediate mock objects.
    describe '#size #country_size' do
      let(:order) { double 'order', site_version: 'SITE' }
      let(:item)  { double 'item' }

      subject(:presenter) { described_class.new(item, order) }

      it 'reverts to unknown for missing dress sizes' do
        allow(item).to receive_message_chain('personalization')         { nil }
        allow(item).to receive_message_chain('variant.dress_size.name') { nil }

        expect(presenter.size).to         eq 'Unknown Size'
        expect(presenter.country_size).to eq 'Unknown Size (SITE)'
      end

      it 'uses size from personalisation' do
        allow(item).to receive_message_chain('personalization.size.name') { 'JustRight' }
        allow(item).to receive_message_chain('variant')                   { nil }

        expect(presenter.size).to eq         'JustRight'
        expect(presenter.country_size).to eq 'JustRight (SITE)'
      end

      it 'uses size from variant' do
        allow(item).to receive_message_chain('personalization')         { nil }
        allow(item).to receive_message_chain('variant.dress_size.name') { 'TeenyTiny' }

        expect(presenter.size).to eq         'TeenyTiny'
        expect(presenter.country_size).to eq 'TeenyTiny (SITE)'
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

        it { is_expected.to eq :some_state }
      end

      context 'fallback' do
        let(:fabrication) { nil }

        it { is_expected.to eq :processing }
      end
    end

    describe '#extended_style_number' do
      before(:each) { expect(presenter).to receive(:global_sku).and_return(global_sku) }

      context 'given a global SKU with an extended style number' do
        let(:global_sku) { GlobalSku.new(data: { 'extended-style-number' => 'SUPER-STYLE-NUMBER' }) }

        it { expect(presenter.extended_style_number).to eq('SUPER-STYLE-NUMBER') }
      end

      context 'given a global SKU without an extended style number' do
        let(:global_sku) { GlobalSku.new(data: nil) }

        it { expect(presenter.extended_style_number).to eq(nil) }
      end
    end
  end
end
