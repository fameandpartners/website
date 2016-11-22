class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.string  :event_type
      t.integer :number_of_assistants
      t.date    :date
      t.timestamps
    end
  end

  def down
    drop_table :events
  end
end
