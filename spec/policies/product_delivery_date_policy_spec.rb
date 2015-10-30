require 'spec_helper'

describe Policies::ProjectDeliveryDatePolicy do
  let(:print_dress)            { create(:spree_product, name:"print", description:"Print", price: 0) }
  let(:beading_dress)          { create(:spree_product, name:"bead", description:"Beading", price: 0) }
  let(:embroid_dress)          { create(:spree_product, name:"embroid", description:"Embroid", price: 0) }
  let(:fast_making_dress)      { create(:spree_product, name:"test fast making", price: 0) }
  let(:standard_dress)         { create(:spree_product, name:"test standard dress", price: 0) }

  context "get delivery date" do
    it "return correct delivery date for a printed dress" do
      service = Policies::ProjectDeliveryDatePolicy.new(print_dress)
      service.printed?.should_not be_nil
      expect(service.special_order?).to eq(true)
      expect(service.delivery_date).to eq({:days_for_making => 9, :days_for_delivery => 4})
    end

    it "return correct delivery date for a beading dress" do
      service = Policies::ProjectDeliveryDatePolicy.new(beading_dress)
      service.beading?.should_not be_nil
      expect(service.special_order?).to eq(true)
      expect(service.delivery_date).to eq({:days_for_making => 9, :days_for_delivery => 4})
    end

    it "return correct delivery date for a embroid dress" do
      service = Policies::ProjectDeliveryDatePolicy.new(embroid_dress)
      service.embroidered?.should_not be_nil
      expect(service.special_order?).to eq(true)
      expect(service.delivery_date).to eq({:days_for_making => 9, :days_for_delivery => 4})
    end

    it "return correct delivery date for a fast making dress" do
      service = Policies::ProjectDeliveryDatePolicy.new(fast_making_dress)
      allow(service).to receive(:fast_making?).and_return(true)
      expect(service.delivery_date).to eq({:days_for_making => 5, :days_for_delivery => 4})
    end

    it "return correct delivery date for a standard dress" do
      service = Policies::ProjectDeliveryDatePolicy.new(standard_dress)
      allow(service).to receive(:fast_making?).and_return(false)
      expect(service.delivery_date).to eq({:days_for_making => 7, :days_for_delivery => 4})
    end
  end
end
