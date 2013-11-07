class AddLastQuizNotificationSentAtToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :last_quiz_notification_sent_at, :datetime
  end
end
