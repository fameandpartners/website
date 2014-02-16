class ChangeLimitOfContentInMoodboardItems < ActiveRecord::Migration
  def up
    change_column :moodboard_items, :content, :string, limit: 512
  end

  def down
    change_column :moodboard_items, :content, :string, limit: nil
  end
end
