class AddSessionKeyToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :session_key, :string
  end
end
