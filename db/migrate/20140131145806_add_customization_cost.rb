class AddCustomizationCost < ActiveRecord::Migration
  def up
    add_column :line_item_personalizations, :price, :decimal, precision: 8, scale: 2, default: 0.0
  end

  def down
    remove_column :line_item_personalizations, :price
  end
end
