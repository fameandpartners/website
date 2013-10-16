class RemoveBodyShapeIdFromLineItemPersonalizations < ActiveRecord::Migration
  def up
    remove_column :line_item_personalizations, :body_shape_id
  end

  def down
    add_column :line_item_personalizations, :body_shape_id, :integer
  end
end
