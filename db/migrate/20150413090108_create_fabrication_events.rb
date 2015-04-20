class CreateFabricationEvents < ActiveRecord::Migration
  def change
    create_table :fabrication_events do |t|
      t.string :fabrication_uuid
      t.string :event_type
      t.text :data
      t.datetime :created_at
      t.datetime :occurred_at
    end
    add_index :fabrication_events, :fabrication_uuid
  end
end

