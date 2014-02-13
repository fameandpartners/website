class AddBlogFixes < ActiveRecord::Migration
  def up
    add_column :blog_posts, :description, :string
  end

  def down
    remove_column :blog_posts, :description, :string
  end
end
