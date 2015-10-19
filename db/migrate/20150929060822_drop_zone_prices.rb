class DropZonePrices < ActiveRecord::Migration
  def up
    drop_table :spree_zone_prices
  end

  def down
    raise IrreversibleMigration
  end
end
