class UpdateWishlistItemProperties < ActiveRecord::Migration
  def up
    add_column :wishlist_items, :quantity, :integer, default: 1
    add_column :wishlist_items, :spree_product_id, :integer

    WishlistItem.delete_all
  end

  def down
    remove_column :wishlist_items, :quantity
    remove_column :wishlist_items, :spree_product_id
  end
end
