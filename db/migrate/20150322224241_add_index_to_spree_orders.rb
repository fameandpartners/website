class AddIndexToSpreeOrders < ActiveRecord::Migration
  def change
    add_index :spree_orders, :user_id
    add_index :spree_orders, :created_at
  end
end
