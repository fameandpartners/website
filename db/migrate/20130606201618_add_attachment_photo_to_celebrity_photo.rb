class AddAttachmentPhotoToCelebrityPhoto < ActiveRecord::Migration
  def self.up
    remove_column :celebrity_photos, :photo
    add_column :celebrity_photos, :photo_file_name, :string
    add_column :celebrity_photos, :photo_content_type, :string
    add_column :celebrity_photos, :photo_file_size, :integer
    add_column :celebrity_photos, :photo_updated_at, :datetime
  end

  def self.down
    remove_column :celebrity_photos, :photo_file_name
    remove_column :celebrity_photos, :photo_content_type
    remove_column :celebrity_photos, :photo_file_size
    remove_column :celebrity_photos, :photo_updated_at
    add_column :celebrity_photos, :photo, :string
  end
end
