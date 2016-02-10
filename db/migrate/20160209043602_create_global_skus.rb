class CreateGlobalSkus < ActiveRecord::Migration
  def change
    create_table :global_skus do |t|
      t.string :sku
      t.string :style_number
      t.string :product_name
      t.string :size
      t.string :color_id
      t.string :color_name
      t.string :customisation_id
      t.string :customisation_name
      t.string :height_value
      t.text   :data
      t.references :product
      t.references :variant


      # :sku, :style_number, :product_name, :variant_id, :size, :color_id, :color_name, :customisation_id, :customisation_name, :height_value, :total_sold, :total_cart

      t.timestamps
    end
    add_index :global_skus, :product_id
    add_index :global_skus, :variant_id
  end
end
