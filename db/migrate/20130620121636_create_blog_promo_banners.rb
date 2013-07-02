class CreateBlogPromoBanners < ActiveRecord::Migration
  def change
    create_table :blog_promo_banners do |t|
      t.string :url
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.datetime :created_at
      t.datetime :updated_at
      t.integer :user_id
      t.string :title
      t.integer :position
      t.boolean :published

      t.timestamps
    end

    add_index :blog_promo_banners, :user_id
    add_index :blog_promo_banners, :published
  end
end
