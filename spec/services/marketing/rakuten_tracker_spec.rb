require 'spec_helper'

describe Marketing::RakutenTracker do

  def item(price = 100, quantity=1)
    product = double(:sku => 'sku', :name => 'name')
    variant = double(:product => product, :sku => 'sku')
    double(:variant => variant, :quantity => quantity, :price => BigDecimal.new(price))
  end

  let(:promo_total) { 0 }
  let(:line_items)  { [item, item, item(110, 2)] }
  let(:order)       { double(:number => 'ABCDEF123', :line_items => line_items) }

  subject(:tracker) { Marketing::RakutenTracker.new(order, site_version) }

  before do
    # allow(tracker).to receive(:promo_total).and_return(promo_total)
    allow(order).to receive_message_chain(:adjustments, :where, :sum).and_return(promo_total)
  end

  context 'us' do
    let(:site_version)  { double(:is_usa? => true, :is_australia? => false) }

    it '#qlist' do
      expect(tracker.qlist).to eq '1|1|2'
    end

    it '#amtlist' do
      expect(tracker.amtlist).to eq '10000|10000|22000'
    end

    it '#url' do
      expect(tracker.url).to be_present
    end

    context 'with discount' do

      let(:promo_total) { -10 }

      it '#skulist' do
        expect(tracker.skulist).to eq 'sku|sku|sku|Discount'
      end

      it '#qlist' do
        expect(tracker.qlist).to eq '1|1|2|0'
      end

      it '#amtlist' do
        expect(tracker.amtlist).to eq '10000|10000|22000|-1000'
      end
    end
  end

  context 'au' do
    let(:site_version)  { double(:is_usa? => false, :is_australia? => true) }

    it '#qlist' do
      expect(tracker.qlist).to eq '1|1|2'
    end

    it '#amt' do
      expect(tracker.amtlist).to eq '9091|9091|20000'
    end

    it '#url' do
      expect(tracker.url).to be_present
    end

    context 'with discount' do

      let(:promo_total) { BigDecimal(-10) }

      it '#skulist' do
        expect(tracker.skulist).to eq 'sku|sku|sku|Discount'
      end

      it '#qlist' do
        expect(tracker.qlist).to eq '1|1|2|0'
      end

      it '#amtlist' do
        expect(tracker.amtlist).to eq '9091|9091|20000|-909'
      end
    end
  end


end
