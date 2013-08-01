class AddGuestUserInfoToOrder < ActiveRecord::Migration
  def change
    add_column :spree_orders, :user_first_name, :string
    add_column :spree_orders, :user_last_name, :string
  end
end
