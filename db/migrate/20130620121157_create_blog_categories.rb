class CreateBlogCategories < ActiveRecord::Migration
  def change
    create_table :blog_categories do |t|
      t.string :name
      t.datetime :created_at
      t.datetime :updated_at
      t.integer :user_id
      t.integer :posts_count
      t.string :slug

      t.timestamps
    end

    add_index :blog_categories, :user_id
    add_index :blog_categories, :slug
  end
end
