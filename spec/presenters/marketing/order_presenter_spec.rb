require 'spec_helper'

describe Marketing::OrderPresenter, type: :presenter do
  let(:presenter) { described_class.new(order) }

  describe 'delegates to Spree::Order' do
    let(:order) { build_stubbed(:spree_order, number: 'R123', currency: 'BRL') }

    it('#number')   { expect(presenter.number).to eq('R123') }
    it('#currency') { expect(presenter.currency).to eq('BRL') }
  end

  describe 'class methods' do
    let(:dress_item) { build(:dress_item, price: 9.99, quantity: 1) }
    let(:adjustment) { build(:adjustment, adjustable_type: 'Spree::Order') }
    let(:order) { build_stubbed(:spree_order, number: 'R123', currency: 'BRL',line_items: [dress_item], adjustments: [adjustment], projected_delivery_date: Date.new) }
  end

  describe 'instance methods' do
    let(:order) { build_stubbed(:spree_order) }

    describe '#total_amount' do
      it 'returns the total amount of an order' do
        allow(order).to receive(:total).and_return(12.34)
        expect(presenter.total_amount).to eq(12.34)
      end
    end

    describe '#taxes_amount' do
      let(:adjustment) { create(:adjustment, amount: 12.3) }

      before(:each) do
        active_record_relation = Spree::Adjustment.where(id: adjustment.id)
        allow(order).to receive_message_chain(:adjustments, :tax).and_return(active_record_relation)
      end

      it 'returns the total tax amount' do
        expect(presenter.taxes_amount).to eq(12.3)
      end
    end

    describe '#shipping_amount' do
      let(:adjustment) { create(:adjustment, amount: 12.3) }

      before(:each) do
        active_record_relation = Spree::Adjustment.where(id: adjustment.id)
        allow(order).to receive_message_chain(:adjustments, :shipping).and_return(active_record_relation)
      end

      it 'returns the total shipping cost' do
        expect(presenter.shipping_amount).to eq(12.3)
      end
    end
  end
end
