class AddIndexActivityAction < ActiveRecord::Migration
  def change
    add_index :activities, :action
    add_index :activities, :owner_type
  end
end
