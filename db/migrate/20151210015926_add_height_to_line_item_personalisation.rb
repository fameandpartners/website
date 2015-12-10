class AddHeightToLineItemPersonalisation < ActiveRecord::Migration
  def change
    add_column :line_item_personalizations, :height, :string, default: 'standard'
  end
end
