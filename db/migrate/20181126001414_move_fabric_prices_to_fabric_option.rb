class MoveFabricPricesToFabricOption < ActiveRecord::Migration
  def change
    add_column :fabrics_products, :price_aud, :decimal, :precision => 8, :scale => 2
    add_column :fabrics_products, :price_usd, :decimal, :precision => 8, :scale => 2

    rename_column :fabrics, :price_usd, :old_price_usd
    rename_column :fabrics, :price_aud, :old_price_aud

    FabricsProduct.includes(:fabric).each do |fp|
      if fp.recommended?
        fp.price_aud = 0
        fp.price_usd = 0
        fp.save!
      else
        fp.price_aud = fp.fabric.old_price_aud
        fp.price_usd = fp.fabric.old_price_usd
        fp.save!
      end
    end
  end
end
