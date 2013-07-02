class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :posts, force: true do |t|
      t.string :title
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end
end
