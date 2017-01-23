require 'spec_helper'

describe Policies::ProductDeliveryPeriodPolicy, type: :policy do
  let(:product) { FactoryGirl.build(:dress) }
  subject { described_class.new(product) }

  describe '#minimum_delivery_period' do
    it "returns minimal delivery period if product has no taxons" do
      expect(subject.minimum_delivery_period).to eq('7 - 10 business days')
    end

    it "returns minimum delivery period from taxons" do
      product.taxons << FactoryGirl.create(:taxon, delivery_period: '14 - 28 business days')
      expect(subject.minimum_delivery_period).to eq('14 - 28 business days')

      product.taxons << FactoryGirl.create(:taxon, delivery_period: '10 - 14 business days')
      expect(subject.minimum_delivery_period).to eq('10 - 14 business days')

      product.taxons << FactoryGirl.create(:taxon, delivery_period: '14 - 28 business days')
      expect(subject.minimum_delivery_period).to eq('10 - 14 business days')
    end
  end

  describe '#delivery_period' do
    it "returns minimum delivery period by default" do
      expect(subject.delivery_period).to eq('7 - 10 business days')
    end

    it "returns cny delivery period if cny flag enabled" do
      Features.activate(:cny_delivery_delays)

      expect(subject.delivery_period).to eq('3 - 4 weeks')
    end
  end
end
