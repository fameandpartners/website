class AddLastPaymentFailedNotificationSentAtToSpreeUser < ActiveRecord::Migration
  def change
    add_column :spree_users, :last_payment_failed_notification_sent_at, :datetime
  end
end
