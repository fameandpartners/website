class RemoveSomeOtherTables < ActiveRecord::Migration
  def change
    drop_table :celebrity_photos_posts
    drop_table :celebrity_photos_red_carpet_events
    drop_table :photo_posts
  end
end
