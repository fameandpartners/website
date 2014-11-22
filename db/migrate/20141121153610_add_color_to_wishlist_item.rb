class AddColorToWishlistItem < ActiveRecord::Migration
  def change
    add_column :wishlist_items, :product_color_id, :integer
  end
end
