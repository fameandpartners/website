class AddGiftIdToOrder < ActiveRecord::Migration
  def up
    add_column :spree_orders, :gift_id, :integer, default: nil
  end

  def down
    remove_column :spree_orders, :gift_id
  end
end
