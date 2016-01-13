class AddIndexToBanners < ActiveRecord::Migration
  def change
    add_index :revolution_banners, :translation_id
  end
end
