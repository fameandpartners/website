class CreateRedCarpetEvents < ActiveRecord::Migration
  def change
    create_table :red_carpet_events do |t|
      t.float :latitude
      t.float :longitude
      t.string :name
      t.string :short_name
      t.text :content
      t.date :event_date
      t.integer :user_id
      t.string :location

      t.timestamps
    end

    add_index :red_carpet_events, :user_id
  end
end
