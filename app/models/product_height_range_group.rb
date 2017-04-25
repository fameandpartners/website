class ProductHeightRangeGroup < ActiveRecord::Base
  attr_accessible :name, :unit

  has_many :product_height_ranges

  scope :defaults, -> { where(name: ['default_three_size_metric_group', 'default_three_size_english_group']) }
  # alias scope
  singleton_class.send(:alias_method, :default_three, :defaults)

  scope :default_six, -> { where(name: ['default_six_size_metric_group', 'default_six_size_english_group']) }
end
