class AddProductMakingOptions < ActiveRecord::Migration
  def up
    create_table :product_making_options, force: true do |t|
      t.references  :product
      t.references  :variant
      t.boolean     :active, default: false
      t.string      :option_type
      t.decimal     :price, precision: 10, scale: 2
      t.string      :currency, limit: 10
    end

    create_table :line_item_making_options, force: true do |t|
      t.references  :product
      t.references  :variant
      t.references  :line_item
      t.references  :making_option
      t.decimal     :price, precision: 10, scale: 2
      t.string      :currency, limit: 10

      t.timestamps
    end

    add_index :product_making_options,    [:product_id, :active, :option_type], name: 'index_product_making_options_on_product_id'
    add_index :line_item_making_options,  [:line_item_id], name: 'index_line_item_making_options_on_line_item'
  end

  def down
    drop_table :product_making_options
    drop_table :line_item_making_options
  end
end
