require 'spec_helper'

RSpec.describe MailChimp::Order, type: :model do

  let(:order) { create(:complete_order_with_items) }
  let(:user) { build(:spree_user) }

  before do
    allow(user).to receive(:id).and_return(1)
    allow(user).to receive(:email).and_return('user1@gmail.com')
    allow(user).to receive(:first_name).and_return('first_name_1')
    allow(user).to receive(:last_name).and_return('last_name_1')
    allow(order).to receive(:user).and_return(user)
    allow(order).to receive(:number).and_return('R123456789')
    allow(order.line_items.first).to receive(:id).and_return(1)
    allow(order.line_items.first.variant.product).to receive(:sku).and_return('sku-1')
  end

  describe('::Exists', :vcr) do

    it('should check if order exists') do
      result = described_class::Exists.(order)
      expect(result).to eql(false)
    end
  end

  describe('::Create', :vcr) do

    it('should create order') do
      result = described_class::Create.(order)
      expect(result).to eql(true)
    end
  end
end
