class CreateCelebrityPhotosPosts < ActiveRecord::Migration
  def up
    create_table :celebrity_photos_posts, id: false do |f|
      f.integer :post_id, null: false
      f.integer :celebrity_photo_id, null: false
    end

    add_index :celebrity_photos_posts, [:post_id, :celebrity_photo_id], unique: true
  end

  def down
    drop_table :celebrity_photos_posts
  end
end
