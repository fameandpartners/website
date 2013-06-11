class AddCategoryIdToPhotoPosts < ActiveRecord::Migration
  def change
    add_column :photo_posts, :category_id, :integer
  end
end
