namespace :data do
    desc 'Create Fabric Color Option Type'
	task :create_fabric_color_option_type => :environment do

		option_value_type = Spree::OptionType.new
		option_value_type.name = 'dress-fabric-color'
		option_value_type.presentation = 'Fabric'
		option_value_type.save!
	end
end
