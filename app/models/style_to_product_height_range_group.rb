class StyleToProductHeightRangeGroup < ActiveRecord::Base
  attr_accessible :product_height_range_group_id, :style_number, :product_height_range_group
  belongs_to :product_height_range_group

  scope :with_style_number, ->(style_number) { where(style_number: style_number) }

  def self.find_both_for_variant_or_use_default( variant )
    style_number  = variant&.product&.sku
    height_groups = StyleToProductHeightRangeGroup.where(style_number: style_number )
    with_style_number(style_number).presence || ProductHeightRangeGroup.defaults
  end

  def self.map_height_values_to_height_name( variant, height_value, height_units )
    height_groups = find_both_for_variant_or_use_default(variant).where(unit: height_units).first
    height_groups.product_height_ranges.where( "min <= ? and max >= ?", height_value.to_i, height_value.to_i ).pluck(:map_to).first
  end
  
  
end
