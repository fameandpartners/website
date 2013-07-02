class AddDescriptionToPromoBanners < ActiveRecord::Migration
  def change
    add_column :blog_promo_banners, :description, :text
  end
end
