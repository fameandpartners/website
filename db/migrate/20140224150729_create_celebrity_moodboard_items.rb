class CreateCelebrityMoodboardItems < ActiveRecord::Migration
  def change
    create_table :celebrity_moodboard_items do |t|
      t.references :celebrity
      t.boolean   :active, default: true
      t.string    :side
      t.integer   :position, default: 0

      t.string    :image_file_name
      t.string    :image_content_type
      t.integer   :image_file_size
      t.datetime  :image_updated_at

      t.timestamps
    end

    add_index :celebrity_moodboard_items, :side
  end
end
