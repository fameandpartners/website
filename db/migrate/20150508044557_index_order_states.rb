class IndexOrderStates < ActiveRecord::Migration
  def change
    add_index :spree_orders, :completed_at
    add_index :spree_orders, :state
  end
end
