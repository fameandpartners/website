class AddStatusReturnInventoryItems < ActiveRecord::Migration
  def change
    add_column :return_inventory_items, :active, :boolean, default: true

    add_index :return_inventory_items, [:active, :available]
  end
end
