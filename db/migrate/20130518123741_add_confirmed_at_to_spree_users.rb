class AddConfirmedAtToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :confirmed_at, :datetime
  end
end
