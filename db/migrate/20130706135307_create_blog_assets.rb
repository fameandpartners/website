class CreateBlogAssets < ActiveRecord::Migration
  def change
    create_table :blog_assets do |t|
      t.has_attached_file :photo
      t.timestamps
      t.integer  :user_id
      t.integer  :post_id
      t.integer  :asset_type
    end

    add_index :blog_assets, :user_id
    add_index :blog_assets, :post_id
  end
end
