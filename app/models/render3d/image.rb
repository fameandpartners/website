module Render3d
  class Image < ActiveRecord::Base
    belongs_to :spree_product, class_name: 'Spree::Product'
    belongs_to :customisation_value
    belongs_to :product_color_value

    validates :customisation_value,
              :product_color_value,
              :spree_product,
              presence: true
  end
end
