class AddMoodboardUserLikes < ActiveRecord::Migration
  def change
    add_column :moodboard_items, :user_likes, :string, default: ''
  end
end
