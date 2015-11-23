class CreateMoodboardItemEvents < ActiveRecord::Migration
  def change
    create_table :moodboard_item_events do |t|
      t.string :moodboard_item_uuid
      t.string :event_type
      t.text :data
      t.datetime :created_at
      t.datetime :occurred_at
    end
    add_index :moodboard_item_events, :moodboard_item_uuid
  end
end

