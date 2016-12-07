require 'spec_helper'

describe Policies::OrderProjectedDeliveryDatePolicy do
  let(:completed_at)  { DateTime.parse('Wed April 1 2015') }
  let(:standard_order)         { double(Spree::Order, :completed_at => completed_at, :has_fast_making_items? => false ) }
  let(:express_delivery_order) { double(Spree::Order, :completed_at => completed_at, :has_fast_making_items? => true ) }

  context "#delivery_date" do
    it "7 business days for standard delivey" do
      service =  Policies::OrderProjectedDeliveryDatePolicy.new(standard_order) 
      expected_date = DateTime.parse('Friday April 10 2015')
      expect(service.delivery_date).to eq expected_date
    end

    it "2 business days for express delivery" do
      service =  Policies::OrderProjectedDeliveryDatePolicy.new(express_delivery_order) 
      expected_date = DateTime.parse('Friday April 3 2015')
      expect(service.delivery_date).to eq expected_date
    end
  end
end
