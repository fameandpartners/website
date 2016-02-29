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

      t.timestamps
    end

    add_index :global_skus, :product_id
    add_index :global_skus, :variant_id

    execute("ALTER SEQUENCE global_skus_id_seq START with 10000 RESTART;")

  end
end
