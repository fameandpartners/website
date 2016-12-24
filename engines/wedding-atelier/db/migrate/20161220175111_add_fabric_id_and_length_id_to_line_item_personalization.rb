class AddFabricIdAndLengthIdToLineItemPersonalization < ActiveRecord::Migration
  def change
    add_column :line_item_personalizations, :fabric_id, :integer
    add_column :line_item_personalizations, :length_id, :integer
  end
end
