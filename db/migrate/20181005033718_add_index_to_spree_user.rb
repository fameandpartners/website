class AddIndexToSpreeUser < ActiveRecord::Migration
  def change
    add_index :spree_users, :authentication_token
  end
end
