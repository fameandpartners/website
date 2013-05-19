class AddConfirmationSentAtToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :confirmation_sent_at, :datetime
  end
end
