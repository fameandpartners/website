class RemoveSomeOtherTables < ActiveRecord::Migration
  def change
    drop_table :celebrity_photos_posts if table_exists? :celebrity_photos_posts
    drop_table :celebrity_photos_red_carpet_events if table_exists? :celebrity_photos_red_carpet_events
    drop_table :photo_posts if table_exists? :photo_posts
  end
end
