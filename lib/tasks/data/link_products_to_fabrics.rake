namespace :data do
    desc 'link products to fabrics'
	task :link_products_to_fabrics => :environment do

		STYLE_FABRIC_HASH = {
			'FPSS13062' => ['black-silk', 'guava-silk'] # Just an example this needs to be filled out
		}

		STYLE_FABRIC_HASH.each_key do |key|
			link_product_to_fabric(key, STYLE_FABRIC_HASH[key])
		end
	end

	def link_product_to_fabric(style_number, fabrics)
		variant = Spree::Variant.find_by_sku(style_number) # should get master vairant
		product = variant.product
		fabrics.each do |fabric_name|
			fabric = Fabric.find_by_name(fabric_name)
			product.fabrics << fabric
		end
	end
end