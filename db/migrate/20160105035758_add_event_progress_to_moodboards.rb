class AddEventProgressToMoodboards < ActiveRecord::Migration
  def change
    add_column :moodboards, :event_progress,     :string
    add_column :moodboards, :owner_relationship, :string
    add_column :moodboards, :guest_count,        :string
    add_column :moodboards, :bride_first_name,   :string
    add_column :moodboards, :bride_last_name,    :string
  end
end
