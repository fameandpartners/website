class MoodboardItem < ActiveRecord::Base
  attr_accessible :spree_product_id, :image, :item_type, :content, :active

  belongs_to :product, class_name: 'Spree::Product', foreign_key: :spree_product_id

  has_attached_file :image, styles: { product: "375x480#", thumbnail: "187x240#" }

  default_scope order: 'position asc'

  scope :active, where(active: true)

  ITEM_TYPES = %w{ moodboard link song }
  ITEM_TYPES.each do |scope_name|
    scope scope_name.to_sym, where(item_type: scope_name.to_s)
  end

  validates :item_type, inclusion: ITEM_TYPES, presence: true
end
