namespace :data do
    desc 'create color fabrics for bridesmaids'
	task :add_bridesmaids_fabrics_to_db => :environment do
		fabrics = [
			{ name: '102-1001', material: 'Heavy Georgette', color_name: 'ivory'},
			{ name: '102-1002', material: 'Heavy Georgette', color_name: 'pale-grey'},
			{ name: '102-1003', material: 'Heavy Georgette', color_name: 'black'},
			{ name: '102-1004', material: 'Heavy Georgette', color_name: 'champagne'},
			{ name: '102-1005', material: 'Heavy Georgette', color_name: 'pale-pink'},
			{ name: '102-1006', material: 'Heavy Georgette', color_name: 'blush'},
			{ name: '102-1007', material: 'Heavy Georgette', color_name: 'peach'},
			{ name: '102-1008', material: 'Heavy Georgette', color_name: 'guava'},
			{ name: '102-1009', material: 'Heavy Georgette', color_name: 'red'},
			{ name: '102-1010', material: 'Heavy Georgette', color_name: 'burgundy'},
			{ name: '102-1011', material: 'Heavy Georgette', color_name: 'berry'},
			{ name: '102-1012', material: 'Heavy Georgette', color_name: 'lilac'},
			{ name: '102-1013', material: 'Heavy Georgette', color_name: 'navy'},
			{ name: '102-1014', material: 'Heavy Georgette', color_name: 'royal-blue'},
			{ name: '102-1015', material: 'Heavy Georgette', color_name: 'pale-blue'},
			{ name: '102-1016', material: 'Heavy Georgette', color_name: 'mint'},
			{ name: '102-1017', material: 'Heavy Georgette', color_name: 'bright-turquoise'},
			{ name: '102-1018', material: 'Heavy Georgette', color_name: 'sage-green'},
			{ name: '102-1019', material: 'Heavy Georgette', color_name: 'wine'},
			{ name: '102-1020', material: 'Heavy Georgette', color_name: 'canary-yellow'},
		]
	
		fabrics.each do |fabric|
			create_bridesmaids_fabric(fabric[:name], fabric[:color_name], fabric[:material])
		end
	end

	def create_bridesmaids_fabric(fabric_name, color_name, material)
		color = Spree::OptionValue.find_by_name(color_name) 
		fabric_color_option = find_or_create_fabric_color_option(fabric_name, "#{color.presentation} #{material}")

		fab = Fabric.find_or_create_by_name(fabric_name)
		fab.presentation = "#{color.presentation} #{material}"
		fab.price_aud = LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE
		fab.price_usd = LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE
		fab.option_fabric_color_value = fabric_color_option
		#fab.image_url = fabric[:image_url]
		fab.material = material
		fab.option_value = color
		fab.save!
	end

	private def find_or_create_fabric_color_option(name, presentation)
		fabric_color = Spree::OptionType.fabric_color.option_values.where('LOWER(name) = ?', name).first
		
		if( fabric_color.blank? )
		  fabric_color = Spree::OptionType.fabric_color.option_values.create do |object|
			object.name         = name
			object.presentation = presentation
		  end
		end
		fabric_color
	end
end