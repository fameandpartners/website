class AddPrimaryPhotoIdToCelebrities < ActiveRecord::Migration
  def change
    add_column :blog_celebrities, :primary_photo_id, :integer
    add_index :blog_celebrities, :primary_photo_id
  end
end
