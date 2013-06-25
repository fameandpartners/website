class AddMainPostPhotoIdToPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :primary_photo_id, :integer
  end
end
