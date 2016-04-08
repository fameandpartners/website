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
               line_items: [item],
               shipped?:   'am_shipped?',
               shipped_at: 'shipped_yesterday',
               tracking:   'tracking_44'
        )
      end
      let(:order)         { double('order', shipments: [shipment]) }

      subject(:presenter) { described_class.new(item, order) }

      it 'exposes properties of @shipment' do
        expect(presenter.shipped_at).to eq 'shipped_yesterday'
        expect(presenter.shipped?).to eq 'am_shipped?'
        expect(presenter.tracking_number).to eq 'tracking_44'
      end

      context 'when missing' do
        let(:item)          { double('item') }
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

    describe '#image_url' do
      context 'presenter has an image' do
        let(:attachment) { double('attachment') }
        let(:image)      { double('image', attachment: attachment) }

        before(:each) do
          allow(presenter).to receive_messages(image?: true, image: image)
          allow(attachment).to receive(:url).with(:large).and_return('http://example.com/image_url.jpg')
        end

        it 'returns image url' do
          expect(subject.image_url).to eq('http://example.com/image_url.jpg')
        end
      end

      context 'presenter does not have an image' do
        before(:each) { allow(presenter).to receive(:image?).and_return(false) }

        it 'returns nil' do
          expect(subject.image_url).to be_nil
        end
      end
    end
  end
end
