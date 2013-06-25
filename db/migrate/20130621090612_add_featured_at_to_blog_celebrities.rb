class AddFeaturedAtToBlogCelebrities < ActiveRecord::Migration
  def change
    add_column :blog_celebrities, :featured_at, :datetime
    add_index :blog_celebrities, :featured_at
  end
end
