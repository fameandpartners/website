class CreateLineItemPersonalizations < ActiveRecord::Migration
  def change
    create_table :line_item_personalizations do |t|
      t.integer :line_item_id
      t.integer :product_id
      t.integer :size
      t.integer :height
      t.integer :body_shape_id
      t.string :customization_value_ids

      t.timestamps
    end
  end
end
