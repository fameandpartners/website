class DropBlogAssets < ActiveRecord::Migration
  def change
    drop_table :blog_assets
  end
end
