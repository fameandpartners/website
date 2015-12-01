class AddIndexToMoodboardItemUuid < ActiveRecord::Migration
  def change
    add_index :moodboard_items, :uuid
  end
end
