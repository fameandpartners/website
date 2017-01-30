class Create10kCouponsForTalkable < ActiveRecord::Migration
  def up
    # Generate promocodes like "63794FAF48"
    promo_codes = (1..10_000).map { SecureRandom.hex(5).upcase.gsub('0', 'A') }.uniq

    promo_codes.each do |code|
      # Promotion
      promotion                          = Spree::Promotion.new
      promotion.name                     = 'Talkable Coupon'
      promotion.description              = "Talkable Coupon #{code}"
      promotion.expires_at               = 1.year.from_now
      promotion.starts_at                = 1.days.ago
      promotion.event_name               = 'spree.checkout.coupon_code_added'
      promotion.usage_limit              = 5
      promotion.match_policy             = 'all'
      promotion.code                     = code
      promotion.advertise                = false
      promotion.eligible_to_custom_order = true
      promotion.eligible_to_sale_order   = true
      promotion.require_shipping_charge  = false
      promotion.save

      # Calculator
      calculator                    = Spree::Calculator::FlatRate.create
      calculator.preferred_amount   = 25
      calculator.preferred_currency = 'USD'
      calculator.save

      # Promotion Action
      promotion_action              = Spree::Promotion::Actions::CreateAdjustment.create
      promotion_action.activator_id = promotion.id
      promotion_action.calculator   = calculator
      promotion_action.save
    end
  end

  def down
    # To properly destroy promotions, first, their actions must be taken down
    # Otherwise, calculators will be kept at the database without calculable objects
    Spree::Promotion.where(name: 'Talkable Coupon').find_each do |promotion|
      promotion.actions.map(&:destroy)
      promotion.destroy
    end
  end
end
