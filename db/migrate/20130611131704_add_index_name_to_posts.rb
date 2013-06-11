class AddIndexNameToPosts < ActiveRecord::Migration
  def change
    add_index :posts, :title, unique: true
    add_index :red_carpet_events, :name, unique: true
  end
end
