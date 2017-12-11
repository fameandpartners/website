class AddColorSizeLengthToLineItems < ActiveRecord::Migration
  def up
  	add_column :spree_line_items, :color, :string
  	add_column :spree_line_items, :size, :string
  	add_column :spree_line_items, :length, :string
  end

  def down
  	remove_column :spree_line_items, :color
  	remove_column :spree_line_items, :size
  	remove_column :spree_line_items, :length
  end
end
