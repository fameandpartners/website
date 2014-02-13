class AddAdditionalFieldsToMoodboardItems < ActiveRecord::Migration
  def change
    add_column :moodboard_items, :name,  :string
    add_column :moodboard_items, :title, :string
  end
end
