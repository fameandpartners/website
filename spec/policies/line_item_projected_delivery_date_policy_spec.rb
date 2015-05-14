require 'spec_helper'

describe Policies::LineItemProjectedDeliveryDatePolicy do
  let(:completed_at)  { DateTime.parse('Wed April 1 2015') }
  let(:order)         { double(Spree::Order, :completed_at => completed_at) }

  context "#delivery_date" do
    it "returns express date" do
      line_item = double(Spree::LineItem, :fast_making? => true)
      service =  Policies::LineItemProjectedDeliveryDatePolicy.new(line_item, order) 

      expected_date = DateTime.parse('Friday April 3 2015')
      expect(service.delivery_date).to eq expected_date
    end

    it 'returns standard date' do
      line_item = double(Spree::LineItem, :fast_making? => false)
      service =  Policies::LineItemProjectedDeliveryDatePolicy.new(line_item, order) 

      expected_date = DateTime.parse('Friday April 10 2015')
      expect(service.delivery_date).to eq expected_date
    end
  end
end
