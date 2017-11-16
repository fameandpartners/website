class AddCustomizaionJsonColumn < ActiveRecord::Migration
  def up
  	add_column :spree_line_items, :customizations, :json
  	add_column :spree_products, :customizations, :json
  end

  def down
  	remove_column :spree_orders, :customizations
  	remove_column :spree_products, :customizations
  end
end
