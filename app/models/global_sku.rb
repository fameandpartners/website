class GlobalSku < ActiveRecord::Base
  belongs_to :product
  belongs_to :variant

  attr_accessible :sku,
                  :style_number,
                  :product_name,
                  :size,
                  :color_id,
                  :color_name,
                  :customisation_id,
                  :customisation_name,
                  :height_value,
                  :data,
                  :product,
                  :product_id,
                  :variant,
                  :variant_id

  validates_uniqueness_of :sku

  serialize :data, JSON
end
