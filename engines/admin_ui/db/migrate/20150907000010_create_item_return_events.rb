class CreateItemReturnEvents < ActiveRecord::Migration
  def change
    create_table :item_return_events do |t|
      t.string :item_return_uuid
      t.string :event_type
      t.text :data
      t.datetime :created_at
      t.datetime :occurred_at
    end
    add_index :item_return_events, :item_return_uuid
  end
end

