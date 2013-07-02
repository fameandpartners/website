class AddSlugToAuthors < ActiveRecord::Migration
  def change
    add_column :blog_authors, :slug, :string
    add_index :blog_authors, :slug
  end
end
