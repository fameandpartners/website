class CreateMoodboardComments < ActiveRecord::Migration
  def change
    create_table :moodboard_comments do |t|
      t.references :moodboard_item
      t.integer :user_id
      t.text :comment

      t.timestamps
    end
    add_index :moodboard_comments, :moodboard_item_id
  end
end
