class StyleToProductHeightRangeGroup < ActiveRecord::Base
  attr_accessible :product_height_range_group_id, :style_number

  belongs_to :product_height_range_group

  def self.find_both_for_variant_or_use_default( variant_id )
    style_number  = Spree::Variant.find_by_id( variant_id)&.product&.sku
    height_groups = StyleToProductHeightRangeGroup.where(style_number: style_number )
    height_groups = ProductHeightRangeGroup::DEFAULTS if( height_groups.empty? )
    height_groups
  end
  
end
