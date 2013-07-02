class AddSlugToCelebrities < ActiveRecord::Migration
  def change
    add_column :blog_celebrities, :slug, :string
    add_index :blog_celebrities, :slug
  end
end
