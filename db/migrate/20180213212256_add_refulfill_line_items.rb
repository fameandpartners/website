class AddRefulfillLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :refulfill, :string, default: nil
  end
end
