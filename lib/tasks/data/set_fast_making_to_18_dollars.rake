namespace :data do
  	task :make_fast_making_18_dollars => :environment do
		fast_making_options = ProductMakingOption.where(option_type: 'fast_making')
		fast_making_options.each do |fmo|
			fmo.price = 4 #lowered the price as of 5/24 from $18 to $4
			fmo.save
		end
	end
end
