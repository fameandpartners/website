class CreatePinboardItemEvents < ActiveRecord::Migration
  def change
    create_table :pinboard_item_events do |t|
      t.string :pinboard_item_uuid
      t.string :event_type
      t.text :data
      t.datetime :created_at
      t.datetime :occurred_at
    end
    add_index :pinboard_item_events, :pinboard_item_uuid
  end
end

