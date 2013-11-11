class AddLastWishlistNotificationSentAtToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :last_wishlist_notification_sent_at, :datetime
  end
end
