class DropAuthorsTable < ActiveRecord::Migration
  def change
    drop_table :blog_authors
    drop_table :blog_red_carpet_posts
    remove_column :blog_posts, :author_id
  end
end
