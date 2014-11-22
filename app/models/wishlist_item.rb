class WishlistItem < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User', foreign_key: :spree_user_id
  belongs_to :variant, class_name: 'Spree::Variant', foreign_key: :spree_variant_id
  belongs_to :product, class_name: 'Spree::Product', foreign_key: :spree_product_id

  validates :user,    presence: true
  validates :variant, presence: true

  attr_accessible  :spree_variant_id, :spree_product_id, :product_color_id, :quantity

  validates :quantity, presence: true, numericality: {
    :allow_blank => false,
    :only_integer => true,
    :greater_than_or_equal_to => 1,
  }
end
