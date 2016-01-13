class CreateRevolutionBanners < ActiveRecord::Migration
  def change
    create_table :revolution_banners do |t|
      t.integer :translation_id
      t.string :alt_text
      t.string :size
      t.integer :banner_order
      t.string :banner_file_name
      t.string :banner_content_type
      t.integer :banner_file_size
      t.datetime :banner_updated_at
      t.integer :banner_width
      t.integer :banner_height

      t.timestamps
    end
  end
end
