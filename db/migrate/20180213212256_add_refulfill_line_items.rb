class AddRefulfillLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :return_inventory_item_id, :integer, default: nil
    add_column :spree_line_items, :refulfill_status, :string
  end
end
