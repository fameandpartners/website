class WishlistItemSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :spree_variant_id, :spree_product_id, :quantity
end
