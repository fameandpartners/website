namespace :data do
  	task :add_fastmaking_to_all_products => :environment do
	products = Spree::Product.all
		products.each do |product|
			if Spree::Product.is_new_product?(product.master.sku)
				puts "Ignoring product - #{product.master.sku}"
				next
			end

			if product.making_options.any? {|mo| mo.option_type == 'fast_making'}
				pmo = product.making_options.detect {|mo| mo.option_type == 'fast_making'}
				pmo.active = true
				pmo.save!
			else
				pmo = ProductMakingOption.new
				pmo.product_id = product.id
				pmo.active = true
				pmo.price = 4 #lowered the price as of 5/24 from $18 to $4
				pmo.currency = 'USD'
				pmo.option_type = 'fast_making'
				pmo.save!
			end
		end
  	end
 end
