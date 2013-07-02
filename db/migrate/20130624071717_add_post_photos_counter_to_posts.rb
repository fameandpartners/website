class AddPostPhotosCounterToPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :post_photos_count, :integer
  end
end
