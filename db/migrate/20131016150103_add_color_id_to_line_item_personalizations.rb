class AddColorIdToLineItemPersonalizations < ActiveRecord::Migration
  def change
    add_column :line_item_personalizations, :color_id, :integer
  end
end
