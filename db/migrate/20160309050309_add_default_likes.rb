class AddDefaultLikes < ActiveRecord::Migration
  def up
    change_column_default :moodboard_items, :likes, 0
  end

  def down
    change_column_default :moodboard_items, :likes, nil
  end
end
