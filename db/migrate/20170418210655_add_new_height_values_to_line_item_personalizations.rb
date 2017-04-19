class AddNewHeightValuesToLineItemPersonalizations < ActiveRecord::Migration
  def change
    add_column :line_item_personalizations, :height_value, :string
    add_column :line_item_personalizations, :height_unit, :string
  end
end
