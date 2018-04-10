require 'spec_helper'

describe Policies::ProjectDeliveryDatePolicy do

  context "get delivery date for printed dress" do
    let(:print_dress)            { create(:spree_product, name:"print", description:"Print", price: 0) }
    let(:service)                { described_class.new(print_dress) }

    it "return correct delivery date for a printed dress" do
      expect(service).to be_printed
      expect(service.delivery_date).to eq({:days_for_making => 10, :days_for_delivery => 4})
    end

    it "is a special order" do
      expect(service.special_order?).to eq(true)
    end
  end

  context "get delivery date for beading dress" do
    let(:beading_dress)          { create(:spree_product, name:"bead", description:"Beading", price: 0) }
    let(:service)                { described_class.new(beading_dress) }

    it "return correct delivery date for a beading dress" do
      expect(service).to be_beading
      expect(service.delivery_date).to eq({:days_for_making => 10, :days_for_delivery => 4})
    end

    it "is a special order" do
      expect(service.special_order?).to eq(true)
    end
  end

  context "get delivery date for embroid dress" do
    let(:embroid_dress)          { create(:spree_product, name:"embroid", description:"Embroid", price: 0) }
    let(:service)                { described_class.new(embroid_dress) }

    it "return correct delivery date for a embroid dress" do
      expect(service).to be_embroidered
      expect(service.delivery_date).to eq({:days_for_making => 10, :days_for_delivery => 4})
    end

    it "is a special order" do
      expect(service.special_order?).to eq(true)
    end
  end

  context "get delivery date for fast making dress" do
    let(:fast_making_dress)      { create(:spree_product, name:"test fast making", price: 0) }
    let(:service)                { described_class.new(fast_making_dress) }

    it "return correct delivery date for a fast making dress" do
      allow(service).to receive(:fast_making?).and_return(true)
      expect(service.delivery_date).to eq({:days_for_making => 10, :days_for_delivery => 4})
    end
  end

  context "get delivery date for standard dress" do
    let(:standard_dress)         { create(:spree_product, name:"test standard dress", price: 0) }
    let(:service)                { described_class.new(standard_dress) }
    let(:service_customized)     { described_class.new(standard_dress, true)}

    it "return correct delivery date for a standard dress" do
      allow(service).to receive(:fast_making?).and_return(false)
      expect(service.delivery_date).to eq({:days_for_making => 5, :days_for_delivery => 4})
    end

    it "return correct delivery date for a customized dress" do
      allow(service_customized).to receive(:fast_making?).and_return(false)
      expect(service_customized.delivery_date).to eq({:days_for_making => 10, :days_for_delivery => 4})
    end
  end

end
