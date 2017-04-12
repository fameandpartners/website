class StyleToProductHeightRangeGroup < ActiveRecord::Base
  attr_accessible :product_height_range_group_id, :style_number

  belongs_to :product_height_range_group

  def self.find_both_for_variant_or_use_default( variant )
    style_number  = variant&.product&.sku
    height_groups = StyleToProductHeightRangeGroup.where(style_number: style_number )
    height_groups = ProductHeightRangeGroup.defaults if( height_groups.empty? )
    height_groups
  end

  def self.map_height_values_to_height_name( variant, height_value, height_units )
    height_groups = self.find_both_for_variant_or_use_default( variant ).find { |product_range_group| product_range_group.unit == height_units }

    height_range = height_groups.product_height_ranges.where( "min <= ? and max >= ?", height_value.to_i, height_value.to_i ).first
    height_range.map_to
  end
  
  
end
