class ProductVideo < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product', foreign_key: :spree_product_id
  belongs_to :color, class_name: 'Spree::OptionValue', foreign_key: :spree_option_value_id

  attr_accessible :url, :video_id, :spree_product_id, :position, :color_name, :is_master, :spree_option_value_id
end
