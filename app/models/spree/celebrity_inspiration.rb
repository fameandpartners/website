class Spree::CelebrityInspiration < ActiveRecord::Base
  set_table_name "celebrity_inspirations"

  attr_accessible :photo, :celebrity_name, :celebrity_description

  has_attached_file :photo, styles: { preview: "460x590#", small: "230x295#", thumbnail: "100x100#"}

  belongs_to :product, class_name: 'Spree::Product', foreign_key: :spree_product_id
end
