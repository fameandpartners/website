class CreateBlogPostPhotos < ActiveRecord::Migration
  def change
    create_table :blog_post_photos do |t|
      t.integer :post_id
      t.integer :user_id
      t.has_attached_file :photo
      t.timestamps
    end

    add_index :blog_post_photos, :post_id
    add_index :blog_post_photos, :user_id
  end
end
