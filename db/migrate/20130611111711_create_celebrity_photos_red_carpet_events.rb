class CreateCelebrityPhotosRedCarpetEvents < ActiveRecord::Migration
  def up
    create_table :celebrity_photos_red_carpet_events, id: false do |f|
      f.integer :red_carpet_event_id, null: false
      f.integer :celebrity_photo_id, null: false
    end

    add_index :celebrity_photos_red_carpet_events, [:red_carpet_event_id, :celebrity_photo_id],
              unique: true, name: "index_photos_red_carpet_events"
  end

  def down
    drop_table :celebrity_photos_red_carpet_events
  end
end
