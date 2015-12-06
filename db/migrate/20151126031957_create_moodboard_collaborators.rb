class CreateMoodboardCollaborators < ActiveRecord::Migration
  def change
    create_table :moodboard_collaborators do |t|
      t.references :moodboard
      t.references :user
      t.string :email
      t.string :name
      t.datetime :accepted_at
      t.datetime :deleted_at
      t.string :deleted_by
      t.boolean :mute_notifications

      t.timestamps
    end
    add_index :moodboard_collaborators, :moodboard_id
    add_index :moodboard_collaborators, :user_id
    add_index :moodboard_collaborators, :email
  end
end
