class AddFabricPriceToLineItem < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :fabric_price, :decimal, :precision => 8, :scale => 2

    execute <<-SQL
      update spree_line_items
      set fabric_price = case when currency = 'AUD' then fabrics_products.price_aud else fabrics_products.price_usd end
      from spree_variants, fabrics_products
      where (spree_line_items.variant_id = spree_variants.id) and fabrics_products.product_id = spree_variants.product_id and fabrics_products.fabric_id = spree_line_items.fabric_id
    SQL
  end
end
