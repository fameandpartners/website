class CreateMoodboardItems < ActiveRecord::Migration
  def change
    create_table :moodboard_items do |t|
      t.references :spree_product
      t.boolean   :active, default: true
      t.string    :item_type, limit: 50
      t.string    :content
      t.integer   :position, default: 0

      t.string    :image_file_name
      t.string    :image_content_type
      t.integer   :image_file_size
      t.datetime  :image_updated_at

      t.timestamps
    end
  end
end
