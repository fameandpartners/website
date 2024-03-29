class Fabric < ActiveRecord::Base
  attr_accessible :name, :presentation, :production_code, :image, :material, :taxon_ids, :option_fabric_color_value_id, :option_value_id
  belongs_to :option_value,
 	     class_name: 'Spree::OptionValue'

  belongs_to :option_fabric_color_value,
 	     class_name: 'Spree::OptionValue'

  has_many :line_items,
	   class_name: 'Spree::LineItem'
  has_and_belongs_to_many :products,
          class_name: 'Spree::Product'
  has_and_belongs_to_many :taxons,
          class_name: 'Spree::Taxon'
          
  has_attached_file :image, 
    styles: { 
      xsmall: "128x128#",
      small: "256x256#",
      medium: "384x384#",
      large: '512x512#',

      webp_xsmall: ["128x128#", :webp],
      webp_small: ["256x256#", :webp],
      webp_medium: ["384x384#", :webp],
      webp_large: ['512x512#', :webp],
    },
    convert_options: {
      all: '-sampling-factor 4:2:0 -strip -quality 90 -interlace JPEG -colorspace sRGB'
    },
    path: 'spree/swatches/:id/:style/:basename.:extension'

  def color_groups
    @color_groups = self.option_value.option_values_groups.pluck(:presentation)
  end
end
