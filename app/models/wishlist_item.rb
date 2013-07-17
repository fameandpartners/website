class WishlistItem < ActiveRecord::Base
  belongs_to :user, class_name: 'Spree::User', foreign_key: :spree_user_id
  belongs_to :variant, class_name: 'Spree::Variant', foreign_key: :spree_variant_id

  validates :user,    presence: true
  validates :variant, presence: true
end
