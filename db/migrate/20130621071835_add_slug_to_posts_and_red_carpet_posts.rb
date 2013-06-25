class AddSlugToPostsAndRedCarpetPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :slug, :string
    add_column :blog_red_carpet_posts, :slug, :string

    add_index :blog_posts, [:slug]
    add_index :blog_red_carpet_posts, [:slug]
  end
end
