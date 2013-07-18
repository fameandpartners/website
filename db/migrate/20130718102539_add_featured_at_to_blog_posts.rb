class AddFeaturedAtToBlogPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :featured_at, :datetime
  end
end
