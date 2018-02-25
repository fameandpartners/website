namespace :data do
  	task :make_fast_making_18_dollars => :environment do
		fast_making_options = ProductMakingOption.where(option_type: 'fast_making')
		fast_making_options.each do |fmo|
			fmo.price = 18
			fmo.save
		end
	end
end