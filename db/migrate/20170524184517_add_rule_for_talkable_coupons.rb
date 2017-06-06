class AddRuleForTalkableCoupons < ActiveRecord::Migration
  def up
    Spree::Promotion.where(name: 'Talkable Coupon 5k').select('id').find_each do |promotion|
      Spree::Promotion::Rules::ItemTotal.new.tap do |rule|
        rule.preferred_amount = 199.00
        rule.preferred_operator = '>'
        rule.activator_id = promotion.id
        rule.save
      end
    end
  end

  def down
    Spree::Promotion::Rules::ItemTotal
      .joins('JOIN spree_activators sa ON sa.id = spree_promotion_rules.activator_id')
      .where('sa.name = ?', 'Talkable Coupon 5k')
      .destroy_all
  end
end
