class RenameMoodboardCommentToMoodboardItemComment < ActiveRecord::Migration
  def change
    rename_table :moodboard_comments, :moodboard_item_comments
  end
end
