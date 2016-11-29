class AddHeightDressSizeAndTrendUpdatesToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :height, :string
    add_column :spree_users, :dress_size, :string
    add_column :spree_users, :trend_updates, :string
  end
end
