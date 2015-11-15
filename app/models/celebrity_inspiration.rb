class CelebrityInspiration < ActiveRecord::Base

  attr_accessible :photo, :celebrity_name, :celebrity_description

  has_attached_file :photo, styles: { preview: "418x600#", small: "209x280#", thumbnail: "104x150#"}

  belongs_to :product, class_name: 'Spree::Product', foreign_key: :spree_product_id, inverse_of: :celebrity_inspiration
end
