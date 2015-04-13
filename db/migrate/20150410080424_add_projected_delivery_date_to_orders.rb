class AddProjectedDeliveryDateToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :projected_delivery_date, :text, :null => true
  end
end
