class BridesmaidPartyModuleTablesRemoving < ActiveRecord::Migration
  def up
    remove_promotion_rule(rule_type: 'Spree::Promotion::Rules::BridesmaidPartyMember')
    remove_promotion_rule(rule_type: 'Spree::Promotion::Rules::BridesmaidsCount')

    remove_email_notification_timestamps

    if ActiveRecord::Base.connection.table_exists? :bridesmaid_party_events
      drop_table :bridesmaid_party_events
    end

    if ActiveRecord::Base.connection.table_exists? :bridesmaid_party_members
      drop_table :bridesmaid_party_members
    end

    # 
  end

  def down
  end

  private

    def remove_promotion_rule(rule_type:)
      Spree::Promotion::Rules.const_set(rule_type.split('::').last, Class.new(Spree::PromotionRule))
      
      Spree::PromotionRule.where(type: rule_type).each do |rule|
        # deactivate promotion
        # empty rules set or no valid rules
        if rule.promotion.promotion_rules.all?{|r| r.type == rule_type }
          rule.promotion.update_attributes({ expires_at: Time.now }, { without_protection: true })
        end

        # remove rule
        rule.destroy
      end
    end

    def remove_email_notification_timestamps
      bridesmaid_emails_codes = [
        'share_completed_bridesmaid_profile',
        'bridesmaid_member_not_purchased',
        'concierge_service_offer',
        'reminder_to_brides',
        'promo_for_bride_with_bridesmaids',
        'free_styling_lesson_for_maid_of_honour'
      ]
      EmailNotification.where(code: bridesmaid_emails_codes).delete_all
    end
end
