class CreateSpreeZonePricesTable < ActiveRecord::Migration
  def change
    create_table :spree_zone_prices, force: true do |t|
      t.references :variant
      t.references :zone
      t.decimal :amount, :precision => 8, :scale => 2
      t.string  :currency
    end

    add_index :spree_zone_prices, :variant_id
    add_index :spree_zone_prices, :zone_id
  end
end
