class AddPrcentPriceToLineItemMakingOption < ActiveRecord::Migration
  def change
    add_column :line_item_making_options, :percent_price, :decimal, :precision => 8, :scale => 2
    rename_column :line_item_making_options, :variant_id, :old_variant_id
    rename_column :line_item_making_options, :price, :flat_price
  end
end
