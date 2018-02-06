module BridesmaidHelper

    COLOR_MAP = {
      'Bright Turquoise' => '0000',
      'Pale Blue' => '0001',
      'Blush' =>'0002',
      'Guava' => '0003',
      'Burgundy' => '0004',
      'Champagne' => '0005',
      'Ivory' => '0006',
      'Lilac' => '0007',
      'Mint' => '0008',
      'Pale Grey' => '0009',
      'Pale Pink' => '0010',
      'Peach' => '0011',
      'Red' => '0012',
      'Royal Blue' => '0013',
      'Black' => '0014',
      'Sage Green' => '0015',
      'Berry'=> '0016',
      'Navy' => '0017',
    }

    def self.generate_image(customizations, length, style_number, color)
	    customization_ids = customizations.reject{|y| y['customisation_value']['id'][0].downcase == 'l'}.map{|x| x['customisation_value']['id']}.sort.join('-')
	    customization_ids = customization_ids.blank? ? 'default' : customization_ids
	    return {
	            :id => 0,
	      :position => 0,
	      :original => "http://d1h7wjzwtdym94.cloudfront.net/renders/composites/#{style_number.downcase}/142x142/#{customization_ids}-#{length.downcase}-front-#{COLOR_MAP[color[:presentation]]}.png",
	         :large => "http://d1h7wjzwtdym94.cloudfront.net/renders/composites/#{style_number.downcase}/142x142/#{customization_ids}-#{length.downcase}-front-#{COLOR_MAP[color[:presentation]]}.png",
	        :xlarge => "http://d1h7wjzwtdym94.cloudfront.net/renders/composites/#{style_number.downcase}/800x800/#{customization_ids}-#{length.downcase}-front-#{COLOR_MAP[color[:presentation]]}.png",
	         :small => "http://d1h7wjzwtdym94.cloudfront.net/renders/composites/#{style_number.downcase}/142x142/#{customization_ids}-#{length.downcase}-front-#{COLOR_MAP[color[:presentation]]}.png" 
	    }
    end

end
