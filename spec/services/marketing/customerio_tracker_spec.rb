require 'spec_helper'

describe Marketing::CustomerIOTracker do

  def item(price = 100, quantity=1)
    product = double(:sku => 'sku', :name => 'name')
    variant = double(:product => product, :sku => 'sku')
    double(:variant => variant, :quantity => quantity, :price => BigDecimal.new(price))
  end

  let(:promo_total) { 0 }
  let(:line_items)  { [item, item, item(110, 2)] }
  let(:address)     { double(:city => 'Minas Tirith', :state => double(:text => 'Anorien'), :country => double(:name => 'Gondor')) }
  let(:order)       { double(:number => 'ABCDEF123', :total => 99, :line_items => line_items, :bill_address => address) }

  let(:site_version)  { double(:currency => 'USD', :code => 'us') }
  subject(:tracker) { Marketing::CustomerIOTracker.new(order, site_version) }

  before do
    allow(order).to receive_message_chain(:adjustments, :where, :sum).and_return(promo_total)
  end

  describe '#order_data' do
    it { expect(tracker.order_data).to include(:number => order.number ) }
    it { expect(tracker.order_data[:items].length).to eq 3 }
  end

end
