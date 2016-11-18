class AddHeightAndDressSizeToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :height, :string
    add_column :spree_users, :dress_size, :string
  end
end
