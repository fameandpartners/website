require 'spec_helper'

describe Policies::LineItemProjectedDeliveryDatePolicy do
  let(:completed_at)  { DateTime.parse('Wed April 1 2015') }
  let(:order)         { double(Spree::Order, :completed_at => completed_at) }

  context '#delivery_date' do
    it 'calculates 10 business days for standard delivey' do
      line_item = double(Spree::LineItem, :fast_making? => false)
      service =  described_class.new(order.completed_at, line_item.fast_making?)

      expected_date = DateTime.parse('Friday April 15 2015')
      expect(service.delivery_date).to eq expected_date
    end

    it 'calculates 4 business days for express delivery' do
      line_item = double(Spree::LineItem, :fast_making? => true)
      service =  described_class.new(order.completed_at, line_item.fast_making?)

      expected_date = DateTime.parse('Friday April 7 2015')
      expect(service.delivery_date).to eq expected_date
    end
  end
end
