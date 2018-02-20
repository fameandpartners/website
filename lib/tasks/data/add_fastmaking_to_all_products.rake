namespace :data do
  	task :add_fastmaking_to_all_products => :environment do
  		products = Spree::Product.all
  		products.each do |product|
	  		unless product.making_options.any? {|mo| mo.option_type == 'fast_making' }
	 			pmo = ProductMakingOption.new
	 			pmo.product_id = product.id
	 			pmo.active = true
	 			pmo.price = 18
	 			pmo.currency = 'USD'
	 			pmo.save
 			end
  		end
  	end
 end
