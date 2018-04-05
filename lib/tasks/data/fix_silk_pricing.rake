namespace :data do
  task :fix_silk_pricing => :environment do

		prods = Spree::Product.all.select {|x| x.fabric_products.recommended.any? {|y| y.fabric.material.downcase.include?('silk')} }

		prods.each  do |product|

			variant = product.master

			aud = Spree::Price.find_or_create_by_variant_id_and_currency(variant.id, 'AUD')
			aud.amount = aud.amount - 100
			aud.save

			usd = Spree::Price.find_or_create_by_variant_id_and_currency(variant.id, 'USD')
			usd.amount = usd.amount - 100
			usd.save

			product.fabric_products.recommended.each  do |fp|
				fp.recommended = false
				fp.save
			end

		end

	end
end