class CreateDefaultProductHeightRanges < ActiveRecord::Migration
  def up
    metric_six = ProductHeightRangeGroup.new( name: 'default_six_size_metric_group', unit: 'cm' )
    metric_six.save

    metric_six.product_height_ranges << ProductHeightRange.new( min: 0,   max: 156, unit: 'cm', map_to: 'length1' )
    metric_six.product_height_ranges << ProductHeightRange.new( min: 157, max: 164, unit: 'cm', map_to: 'length2' )
    metric_six.product_height_ranges << ProductHeightRange.new( min: 165, max: 172, unit: 'cm', map_to: 'length3' )
    metric_six.product_height_ranges << ProductHeightRange.new( min: 173, max: 179, unit: 'cm', map_to: 'length4' )
    metric_six.product_height_ranges << ProductHeightRange.new( min: 180, max: 186, unit: 'cm', map_to: 'length5' )
    metric_six.product_height_ranges << ProductHeightRange.new( min: 187, max: 999, unit: 'cm', map_to: 'length6' )


    metric_three = ProductHeightRangeGroup.new( name: 'default_three_size_metric_group', unit: 'cm' )
    metric_three.save
    metric_three.product_height_ranges << ProductHeightRange.new( min: 0,   max: 167, unit: 'cm', map_to: 'petite' )
    metric_three.product_height_ranges << ProductHeightRange.new( min: 168, max: 174, unit: 'cm', map_to: 'standard' )
    metric_three.product_height_ranges << ProductHeightRange.new( min: 175, max: 999, unit: 'cm', map_to: 'tall' )
    
    
    english_six = ProductHeightRangeGroup.new( name: 'default_six_size_english_group', unit: 'inch' )
    english_six.save
    english_six.product_height_ranges << ProductHeightRange.new( min: 0,   max: 61,  unit: 'inch', map_to: 'length1' )
    english_six.product_height_ranges << ProductHeightRange.new( min: 62,  max: 64,  unit: 'inch', map_to: 'length2' )
    english_six.product_height_ranges << ProductHeightRange.new( min: 65,  max: 67,  unit: 'inch', map_to: 'length3' )
    english_six.product_height_ranges << ProductHeightRange.new( min: 68,  max: 70,  unit: 'inch', map_to: 'length4' )
    english_six.product_height_ranges << ProductHeightRange.new( min: 71,  max: 73,  unit: 'inch', map_to: 'length5' )
    english_six.product_height_ranges << ProductHeightRange.new( min: 74,  max: 999, unit: 'inch', map_to: 'length6' )

    english_three = ProductHeightRangeGroup.new( name: 'default_three_size_english_group', unit: 'inch' )
    english_three.save
    english_three.product_height_ranges << ProductHeightRange.new( min: 0,   max: 67,   unit: 'inch', map_to: 'petite' )
    english_three.product_height_ranges << ProductHeightRange.new( min: 68,  max: 70,   unit: 'inch', map_to: 'standard' )
    english_three.product_height_ranges << ProductHeightRange.new( min: 71,  max: 999,  unit: 'inch', map_to: 'tall' )
    
  end

  def down
    delete_if_exists( 'default_six_size_metric_group' )
    delete_if_exists( 'default_three_size_metric_group' )
    delete_if_exists( 'default_six_size_english_group' )
    delete_if_exists( 'default_three_size_english_group' )
  end

  private

  def delete_if_exists( name )
    group = ProductHeightRangeGroup.find_by_name( name )
    group.delete if group.present?
  end
  
  
end
