require 'spec_helper'

describe Policies::LineItemDeliveryPolicy, type: :policy do
  let(:making_option) { FactoryGirl.build(:making_option, delivery_period: '1 week', making_time_business_days: 3, delivery_time_days: 7) }
  let(:product_making_option) { FactoryGirl.build(:product_making_option, making_option: making_option) }
  let(:line_making_option) { FactoryGirl.build(:line_item_making_option, product_making_option: product_making_option) }

  let(:product) { FactoryGirl.build(:dress, making_options: [product_making_option]) }
  let(:order) { FactoryGirl.build(:spree_order, completed_at: Time.new(2018, 01, 01)) }
  let(:line_item) { FactoryGirl.build(:dress_item, product: product, making_options: [line_making_option], order: order) }
  subject { described_class.new(line_item) }

  describe '#delivery_period' do
    it "returns delivery period" do
      expect(subject.delivery_period).to eq('1 week')
    end
  end

  describe '#delivery_date' do
    it "returns delivery period" do
      expect(subject.delivery_date).to eq(Date.new(2018, 01, 8))
    end
  end

  describe '#ship_by_date' do
    it "returns delivery period" do
      expect(subject.ship_by_date).to eq(Date.new(2018, 01, 04))
    end
  end
  
end
