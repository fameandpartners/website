class SetLastNotificationSentTime < ActiveRecord::Migration
  def up
    Spree::User.update_all({
                             last_cart_notification_sent_at: 13.hours.ago,
                             last_wishlist_notification_sent_at: 13.hours.ago,
                             last_quiz_notification_sent_at: 13.hours.ago
                           })
  end

  def down
  end
end
