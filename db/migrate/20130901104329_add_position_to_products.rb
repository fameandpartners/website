class AddPositionToProducts < ActiveRecord::Migration
  def up
    add_column :spree_products, :position, :integer, default: 0
  end

  def down
    remove_column :spree_products, :position
  end
end
