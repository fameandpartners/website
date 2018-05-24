namespace :data do
  	task :set_super_fast_making_price => :environment do
		super_fast_making_options = ProductMakingOption.where(option_type: 'super_fast_making')
		super_fast_making_options.each do |fmo|
			sfmo.price = 19
			sfmo.save
		end
	end
end
