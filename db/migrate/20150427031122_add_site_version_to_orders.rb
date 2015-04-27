class AddSiteVersionToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :site_version, :text, :null => true
  end
end
