class AddFabricIdToLineItemPersonalization < ActiveRecord::Migration
  def change
    add_column :line_item_personalizations, :fabric_id, :integer
  end
end
