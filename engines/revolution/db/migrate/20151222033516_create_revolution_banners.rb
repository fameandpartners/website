class CreateRevolutionBanners < ActiveRecord::Migration
  def change
    create_table :revolution_translation_banners do |t|
      t.integer :translation_id
      t.string :alt_text
      t.integer :size
      t.integer :banner_order
      t.string :banner_file_name
      t.string :banner_content_type
      t.integer :banner_file_size
      t.datetime :banner_updated_at

      t.timestamps
    end
  end
end
