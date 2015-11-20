class CreateMoodboardItems < ActiveRecord::Migration
  def change
    create_table :moodboard_items do |t|
      t.string :uuid
      t.references :moodboard
      t.references :product, null: false
      t.references :product_color_value
      t.references :color, null: false
      t.references :variant
      t.references :user, null: false
      t.integer    :likes
      t.text       :comments
      t.datetime   :deleted_at

      t.timestamps
    end
    add_index :moodboard_items, :moodboard_id
    add_index :moodboard_items, :product_id
    add_index :moodboard_items, :product_color_value_id
    add_index :moodboard_items, :color_id
    add_index :moodboard_items, :variant_id
    add_index :moodboard_items, :user_id
  end
end
