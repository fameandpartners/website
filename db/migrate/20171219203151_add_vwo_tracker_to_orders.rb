class AddVwoTrackerToOrders < ActiveRecord::Migration
  def up
  	add_column :spree_orders, :vwo_type, :string
  end

  def down
  	remove_column :spree_orders, :vwo_type
  end
end
