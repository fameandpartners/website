class CreateBlogAuthors < ActiveRecord::Migration
  def change
    create_table :blog_authors do |t|
      t.string :first_name
      t.string :last_name
      t.datetime :created_at
      t.datetime :updated_at
      t.text :description
      t.integer :user_id

      t.timestamps
    end
    add_index :blog_authors, :user_id
  end
end
