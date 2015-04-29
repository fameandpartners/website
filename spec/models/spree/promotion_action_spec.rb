require 'spec_helper'

describe Spree::Promotion::Actions::CreateAdjustment do
  let(:order)             { Spree::Order.new }
  let(:promotion)         { Spree::Promotion.new(code: 'promocode', name: 'promotion') }
  let(:promotion_action)  { Spree::Promotion::Actions::CreateAdjustment.new() }

  let(:payload) { { order: order, coupon_code: promotion.code }}

  describe "perform" do
    it "create adjustment" do
      expect(order).to receive(:promotion_action_credit_exists?).with(promotion_action).and_return(false)
      expect(promotion_action).to receive(:create_adjustment)

      promotion_action.promotion = promotion
      promotion_action.perform(payload)
    end

    it "skip if adjustment already created" do
      expect(order).to receive(:promotion_action_credit_exists?).with(promotion_action).and_return(true)
      expect(promotion_action).not_to receive(:create_adjustment)

      promotion_action.perform(payload)
    end
  end
end
