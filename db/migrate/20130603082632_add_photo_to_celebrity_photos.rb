class AddPhotoToCelebrityPhotos < ActiveRecord::Migration
  def change
    add_column :blog_celebrity_photos, :photo, :string
  end
end
