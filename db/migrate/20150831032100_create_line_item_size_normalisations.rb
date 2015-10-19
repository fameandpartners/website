class CreateLineItemSizeNormalisations < ActiveRecord::Migration
  def change
    create_table :line_item_size_normalisations do |t|
      t.references :line_item
      t.references :line_item_personalization
      t.string :order_number
      t.datetime :order_created_at
      t.string :currency
      t.string :site_version
      t.string :old_size_value
      t.references :old_size
      t.references :old_variant
      t.string :new_size_value
      t.references :new_size
      t.references :new_variant
      t.string :messages
      t.string :state
      t.datetime :processed_at

      t.timestamps
    end
    add_index :line_item_size_normalisations, :line_item_id
    add_index :line_item_size_normalisations, :old_size_id
    add_index :line_item_size_normalisations, :old_variant_id
    add_index :line_item_size_normalisations, :new_size_id
    add_index :line_item_size_normalisations, :new_variant_id
  end
end
