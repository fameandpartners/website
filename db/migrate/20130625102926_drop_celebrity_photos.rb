class DropCelebrityPhotos < ActiveRecord::Migration
  def change
    drop_table :celebrity_photos
  end
end
