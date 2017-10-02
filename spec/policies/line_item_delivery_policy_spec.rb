require 'spec_helper'

describe Policies::LineItemDeliveryPolicy, type: :policy do
  let(:line_item) { FactoryGirl.build(:dress_item) }
  let(:product) { line_item.product }
  subject { described_class.new(line_item) }

  describe '#maximum_delivery_period' do
    it "returns minimal delivery period if line_item has no taxons" do
      expect(subject.maximum_delivery_period).to eq('7 - 10 business days')
    end

    it "returns maximum delivery period from taxons" do
      product.taxons << FactoryGirl.create(:taxon, delivery_period: '12 - 15 business days')
      expect(subject.maximum_delivery_period).to eq('12 - 15 business days')

      product.taxons << FactoryGirl.create(:taxon, delivery_period: '3 - 4 weeks')
      expect(subject.maximum_delivery_period).to eq('3 - 4 weeks')

      product.taxons << FactoryGirl.create(:taxon, delivery_period: '12 - 15 business days')
      expect(subject.maximum_delivery_period).to eq('3 - 4 weeks')
    end
  end

  describe '#delivery_period' do
    it "returns minimum delivery period by default" do
      expect(subject.delivery_period).to eq('7 - 10 business days')
    end

    it "returns fast making delivery period if line_item is fast making" do
      expect(line_item).to receive(:fast_making?).and_return(true)

      expect(subject.delivery_period).to eq('4 - 6 business days')
    end

    it "returns cny delivery period if cny flag enabled" do
      Features.activate(:cny_delivery_delays)

      expect(subject.delivery_period).to eq('12 - 15 business days')
    end
  end
end
