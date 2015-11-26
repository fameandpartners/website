require_relative '../../app/models/item_price_adjustment_split'

RSpec.describe ItemPriceAdjustmentSplit do
  let(:item_count) { 1 }
  let(:adjustment_total) { 33 }
  let(:price) { 100 }
  let(:order) { double('Order', adjustment_total: adjustment_total) }
  let(:item) { double('LineItem', order: order, price: price) }
  subject(:splitter) { described_class.new(item) }

  before do
    allow(order).to receive_message_chain("line_items.count") { item_count }
  end

  describe '#item_price_in_cents' do
    it 'returns price in cents' do
      expect(splitter.item_price_in_cents).to eq 100_00
    end
  end

  describe '#item_price_adjusted_in_cents' do

    subject(:item_price_adjusted_in_cents) { splitter.item_price_adjusted_in_cents }

    context 'positive adjustments' do
      context 'a single item' do
        let(:item_count) { 1 }
        it 'adds adjustment to price' do
          is_expected.to eq 133_00
        end
      end

      describe 'on multiple items' do
        let(:item_count) { 3 }
        it 'adds $11 of adjustment' do
          is_expected.to eq 111_00
        end
      end
    end

    context 'negative adjustments' do
      let(:adjustment_total) { -20 }

      it 'deducts the adjustment from price' do
        is_expected.to eq 80_00
      end

      describe 'on multiple items' do
        let(:item_count) { 2 }
        it 'deducts a portion of the adjustment' do
          is_expected.to eq 90_00
        end
      end
    end
  end

  describe 'Division By Zero' do
    before do
      allow(order).to receive_message_chain("line_items.count") { 0 }
    end

    it 'wont error Dividing by zero' do
      expect { splitter.item_price_adjusted_in_cents }.to_not raise_error
    end

    it 'wont be given a divisor of zero' do
      expect(splitter.send(:num_items_in_order)).to eq 1
    end
    it 'apportions as if there were one item on order' do
      expect(splitter.item_price_adjusted_in_cents).to eq 133_00
    end
  end
end
