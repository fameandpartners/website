class CreateFabricsTable < ActiveRecord::Migration
   def change
  	create_table :fabrics do |t|
      t.string :name
      t.string :presentation
      t.string :price_aud
      t.string :price_usd
      t.string :material
      t.string :image_url
      t.integer :option_value_id

      t.timestamps
    end

    add_index :fabrics, [:option_value_id], :name => 'index_fabrics_on_option_value_id'

    create_table :fabrics_products do |t|
      t.integer :fabric_id
      t.integer :product_id
    end

    add_column :spree_line_items, :fabric_id, :integer

	add_index :spree_line_items, [:fabric_id], :name => 'index_line_item_on_fabric_id'
  end
end
