class AddColorToLineItemPersonalizations < ActiveRecord::Migration
  def change
    add_column :line_item_personalizations, :color, :string
  end
end
