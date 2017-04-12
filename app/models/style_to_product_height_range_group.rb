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
    find_both_for_variant_or_use_default(variant)
      .where(unit: height_units)
      .product_height_ranges.where('min <= ? AND max >= ?', height_value.to_i, height_value.to_i)
      .pluck(:map_to)
      .first
  end
  
  
end
