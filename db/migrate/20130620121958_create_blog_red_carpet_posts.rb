class CreateBlogRedCarpetPosts < ActiveRecord::Migration
  def change
    create_table :blog_red_carpet_posts do |t|
      t.string :title
      t.text :body
      t.integer :author_id
      t.integer :user_id
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :published_at
      t.datetime :occured_at
      t.integer :category_id

      t.timestamps
    end

    add_index :blog_red_carpet_posts, :author_id
    add_index :blog_red_carpet_posts, :user_id
    add_index :blog_red_carpet_posts, :published_at
    add_index :blog_red_carpet_posts, :category_id
  end
end
