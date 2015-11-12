class CreatePinboardItems < ActiveRecord::Migration
  def change
    create_table :pinboard_items do |t|
      t.references :pinboard, null: false
      t.references :product, null: false
      t.references :variant
      t.references :product_color_value
      t.integer :like_count
      t.integer :added_user_id
      t.text :comments
      t.string :uuid
      t.timestamps
    end
    add_index :pinboard_items, :uuid, :unique => true
  end
end

