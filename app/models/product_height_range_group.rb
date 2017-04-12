class ProductHeightRangeGroup < ActiveRecord::Base
  attr_accessible :name, :unit

  has_many :product_height_ranges

  scope :defaults, -> { where(name: ['default_three_size_metric_group', 'default_three_size_english_group']) }
  
end
