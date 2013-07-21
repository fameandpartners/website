class CreateWishlistItems < ActiveRecord::Migration
  def change
    create_table :wishlist_items, force: true do |t|
      t.references :spree_user
      t.references :spree_variant

      t.timestamps
    end
  end
end
