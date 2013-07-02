class AddPhotoToAuthor < ActiveRecord::Migration
  def change
    change_table :blog_authors do |t|
      t.has_attached_file :photo
    end
  end
end
