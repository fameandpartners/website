class AddMoodboardLikes < ActiveRecord::Migration
  def up
    change_column_default :moodboard_items, :likes, 0
    add_column :moodboard_items, :user_likes, :string, default: ''
  end

  def down
    change_column_default :moodboard_items, :likes, nil
    remove_column :moodboard_items, :user_likes
  end
end
