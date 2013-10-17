class RemoveHeightFromLineItemPersonalizations < ActiveRecord::Migration
  def up
    remove_column :line_item_personalizations, :height
  end

  def down
    add_column :line_item_personalizations, :height, :integer
  end
end
