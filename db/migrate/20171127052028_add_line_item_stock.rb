class AddLineItemStock < ActiveRecord::Migration
  def up
  	add_column :spree_line_items, :stock, :boolean
  end

  def down
  	remove_column :spree_line_items, :stock
  end
end
