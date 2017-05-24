class AddDataFieldForUser < ActiveRecord::Migration
  def up
    add_column :spree_users, :user_data, :text, default: '{}'
  end

  def down
    remove_column :spree_users, :user_data
  end
end
