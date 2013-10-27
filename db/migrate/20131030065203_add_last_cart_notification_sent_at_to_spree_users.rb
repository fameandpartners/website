class AddLastCartNotificationSentAtToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :last_cart_notification_sent_at, :datetime
  end
end
