class CreateBlogPosts1 < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.string    :title
      t.text      :body
      t.integer   :author_id
      t.integer   :user_id
      t.datetime  :created_at
      t.datetime  :updated_at
      t.datetime  :published_at
      t.datetime  :occured_at
      t.integer   :category_id

      t.timestamps
    end

    add_index :blog_posts, [:category_id, :published_at]
    add_index :blog_posts, :author_id
    add_index :blog_posts, :user_id
  end
end
