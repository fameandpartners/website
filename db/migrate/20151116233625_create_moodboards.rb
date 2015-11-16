class CreateMoodboards < ActiveRecord::Migration
  def change
    create_table :moodboards do |t|
      t.references :user
      t.string :name
      t.string :purpose, default: 'default', null: false
      t.date :event_date
      t.text :description

      t.timestamps
    end
    add_index :moodboards, :user_id
  end
end
