class LayerCad < ActiveRecord::Base
  attr_accessible :base_image_name, :position, :customization_1, :customization_2, :customization_3, :customization_4, :layer_image_name, :product_id
end
