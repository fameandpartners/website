class AddIndexToBanners < ActiveRecord::Migration
  def change
    add_index :revolution_translation_banners, :translation_id
  end
end
