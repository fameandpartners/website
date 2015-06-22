require 'spec_helper'

describe Marketing::PolyvoreTracker do

  def item(price = 100, quantity=1)
    product = double(:sku => 'sku', :name => 'name')
    variant = double(:product => product, :sku => 'sku')
    double(:variant => variant, :quantity => quantity, :price => BigDecimal.new(price))
  end

  let(:line_items)  { [item, item, item(110, 2)] }
  let(:order)       { double(:number => 'ABCDEF123', :line_items => line_items, :total => BigDecimal.new('110.00')) }

  subject(:tracker) { Marketing::PolyvoreTracker.new(order, site_version) }

  context 'us' do
    let(:site_version)  { double(:is_usa? => true, :is_australia? => false, :currency => 'usd') }

    it '#order_id' do
      expect(tracker.order_id).to eq order.number
    end

    it '#subtotal' do
      expect(tracker.subtotal).to eq '110.00'
    end

    it '#url' do
      expect(tracker.url).to be_present
      expect(tracker.url).to include(order.number)
      expect(tracker.url).to include('usd')
      expect(tracker.url).to include(order.total.to_s)
    end
  end

  context 'au' do
    let(:site_version)  { double(:is_usa? => false, :is_australia? => true, :currency => 'aud') }

    it '#subtotal' do
      expect(tracker.subtotal).to eq '100.00'
    end

  end

end
