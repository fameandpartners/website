class AddVideoToBlogPost < ActiveRecord::Migration
  def change
    add_column :blog_posts, :video_url,     :string, limit: 512
    add_column :blog_posts, :primary_type,  :string
  end
end
