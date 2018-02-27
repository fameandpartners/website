namespace :data do
    desc 'Create Fabric Color Option Type'
	task :create_fabric_color_option_type => :environment do

		option_value_type = Spree::OptionValueType.new
		option_value_type.name = 'dress-fabric-color'
		option_value_type.presentation = 'Fabric'
		OptionValueType.save!
	end
end