class ProductHeightRangeGroup < ActiveRecord::Base
  attr_accessible :name, :unit

  has_many :product_height_ranges

  DEFAULTS = [ProductHeightRangeGroup.find_by_name( 'default_three_size_metric_group' ), ProductHeightRangeGroup.find_by_name( 'default_three_size_english_group' )]
  
end
