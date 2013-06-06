class AddPhotoToCelebrityPhotos < ActiveRecord::Migration
  def change
    add_column :celebrity_photos, :photo, :string
  end
end
