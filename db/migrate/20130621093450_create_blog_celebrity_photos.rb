class CreateBlogCelebrityPhotos < ActiveRecord::Migration
  def change
    create_table :blog_celebrity_photos do |t|
      t.integer :celebrity_id
      t.integer :post_id
      t.integer :user_id
      t.has_attached_file :photo
      t.integer :likes_count
      t.integer :dislikes_count
      t.datetime :publsihed_at
      t.timestamps
    end

    add_index :blog_celebrity_photos, :celebrity_id
    add_index :blog_celebrity_photos, :post_id
    add_index :blog_celebrity_photos, :user_id
    add_index :blog_celebrity_photos, :publsihed_at
  end
end
