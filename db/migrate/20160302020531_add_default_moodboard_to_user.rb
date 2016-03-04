class AddDefaultMoodboardToUser < ActiveRecord::Migration
  def change
    add_column :spree_users, :active_moodboard_id, :integer, :default => nil
  end
end
