class CreateReturnInventory < ActiveRecord::Migration
  def change
    create_table :return_inventory_items do |t|
      t.integer :upc, null: false
      t.string :style_number
      t.integer :available, null: false
      t.string :vendor, null: false

      t.timestamps
    end

    add_index :return_inventory_items, :upc
    add_index :return_inventory_items, :style_number
  end
end
