class WishlistItemSerializer < ActiveModel::Serializer
  self.root = false
  attributes :spree_variant_id, :spree_product_id, :quantity
end
