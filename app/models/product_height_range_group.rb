class ProductHeightRangeGroup < ActiveRecord::Base
  attr_accessible :name, :unit

  has_many :product_height_ranges

  has_many :style_to_product_height_range_group
  scope :with_style_number, ->(style_number) { joins( :style_to_product_height_range_group ).where( :'style_to_product_height_range_groups.style_number' => style_number ) }
  
  scope :defaults, -> { where(name: ['default_three_size_metric_group', 'default_three_size_english_group']) }
  # alias scope
  singleton_class.send(:alias_method, :default_three, :defaults)

  scope :default_six, -> { where(name: ['default_six_size_metric_group', 'default_six_size_english_group']) }

  def self.find_both_for_variant_or_use_default( variant )
    style_number  = variant&.product&.sku
    with_style_number(style_number).presence&.collect(&:product_height_range_group) || ProductHeightRangeGroup.defaults
  end
  
end
