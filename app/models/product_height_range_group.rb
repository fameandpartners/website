class ProductHeightRangeGroup < ActiveRecord::Base
  attr_accessible :name, :unit

  has_many :product_height_ranges
end
