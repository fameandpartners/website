class AddOldPriceToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :old_price, :decimal, :precision => 8, :scale => 2
  end
end
