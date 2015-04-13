class AddProjectedDeliveryDateToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :projected_delivery_date, :datetime, :null => true
  end
end
