class CreateCelebrityPhotos < ActiveRecord::Migration
  def change
    create_table :celebrity_photos do |t|
      t.integer :celebrity_id
      t.datetime :event_date
      t.string :event_name
      t.integer :user_id

      t.timestamps
    end
  end
end
