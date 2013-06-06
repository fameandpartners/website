class AddUserIdToCelebrityPhotos < ActiveRecord::Migration
  def change
    add_column :celebrity_photos, :user_id, :integer
    add_index :celebrity_photos, :user_id
  end
end
