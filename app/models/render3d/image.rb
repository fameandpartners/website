module Render3d
  class Image < ActiveRecord::Base
    belongs_to :customisation_value
    belongs_to :product_color_value

    validates :customisation_value,
              :product_color_value,
              presence: true
  end
end
