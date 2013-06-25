class FixTypoInNameForCelebrityPhotos < ActiveRecord::Migration
  def change
    remove_index :blog_celebrity_photos, :publsihed_at
    remove_column :blog_celebrity_photos, :publsihed_at

    add_column :blog_celebrity_photos, :published_at, :datetime
    add_index :blog_celebrity_photos, :published_at
  end
end
