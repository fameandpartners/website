class CreateBlogCelebrityLikes < ActiveRecord::Migration
  def change
    create_table :blog_celebrity_photo_votes do |t|
      t.integer :vote_type
      t.integer :user_id
      t.integer :celebrity_photo_id
      t.timestamps
    end
    add_index :blog_celebrity_photo_votes, :user_id
    add_index :blog_celebrity_photo_votes, :celebrity_photo_id

    add_column :blog_celebrities, :celebrity_photo_votes_count, :integer
  end
end
