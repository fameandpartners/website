class CreateDefaultProductHeightRanges < ActiveRecord::Migration
  def up
    metric_six = ProductHeightRangeGroup.create( name: 'default_six_size_metric_group', unit: 'cm' )
    metric_six.product_height_ranges << ProductHeightRange.new( min: 0,   max: 156, unit: 'cm', map_to: 'length1' )
    metric_six.product_height_ranges << ProductHeightRange.new( min: 157, max: 164, unit: 'cm', map_to: 'length2' )
    metric_six.product_height_ranges << ProductHeightRange.new( min: 165, max: 172, unit: 'cm', map_to: 'length3' )
    metric_six.product_height_ranges << ProductHeightRange.new( min: 173, max: 179, unit: 'cm', map_to: 'length4' )
    metric_six.product_height_ranges << ProductHeightRange.new( min: 180, max: 186, unit: 'cm', map_to: 'length5' )
    metric_six.product_height_ranges << ProductHeightRange.new( min: 187, max: 999, unit: 'cm', map_to: 'length6' )


    metric_three = ProductHeightRangeGroup.create( name: 'default_three_size_metric_group', unit: 'cm' )
    metric_three.product_height_ranges << ProductHeightRange.new( min: 0,   max: 165, unit: 'cm', map_to: 'petite' )
    metric_three.product_height_ranges << ProductHeightRange.new( min: 166, max: 176, unit: 'cm', map_to: 'standard' )
    metric_three.product_height_ranges << ProductHeightRange.new( min: 177, max: 999, unit: 'cm', map_to: 'tall' )
    
    
    english_six = ProductHeightRangeGroup.create( name: 'default_six_size_english_group', unit: 'inch' )
    english_six.product_height_ranges << ProductHeightRange.new( min: 0,   max: 61,  unit: 'inch', map_to: 'length1' )
    english_six.product_height_ranges << ProductHeightRange.new( min: 62,  max: 64,  unit: 'inch', map_to: 'length2' )
    english_six.product_height_ranges << ProductHeightRange.new( min: 65,  max: 67,  unit: 'inch', map_to: 'length3' )
    english_six.product_height_ranges << ProductHeightRange.new( min: 68,  max: 70,  unit: 'inch', map_to: 'length4' )
    english_six.product_height_ranges << ProductHeightRange.new( min: 71,  max: 73,  unit: 'inch', map_to: 'length5' )
    english_six.product_height_ranges << ProductHeightRange.new( min: 74,  max: 999, unit: 'inch', map_to: 'length6' )

    english_three = ProductHeightRangeGroup.create( name: 'default_three_size_english_group', unit: 'inch' )
    english_three.product_height_ranges << ProductHeightRange.new( min: 0,   max: 65,   unit: 'inch', map_to: 'petite' )
    english_three.product_height_ranges << ProductHeightRange.new( min: 66,  max: 69,   unit: 'inch', map_to: 'standard' )
    english_three.product_height_ranges << ProductHeightRange.new( min: 70,  max: 999,  unit: 'inch', map_to: 'tall' )
    
  end

  def down
    names = %w(default_six_size_metric_group default_three_size_metric_group default_six_size_english_group default_three_size_english_group)
    ProductHeightRangeGroup.where(name: names).destroy_all    
  end
  
end
