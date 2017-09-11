module OrderBot
	class Product
		include Spree::OrderBotHelper

		def initialize(line_item, product)
			group_ids = get_or_create_group_id_by_product(product)
			@reference_product_id = product.id # This is going to need to change
			@component_group_id = group_ids[1]
			@group_id = group_ids[0] 
			@description = "#{product.name} &lt;br&gt; &lt;img src=#{line_item.image_url}? width=\"300\"&gt;"
			@create_bom = false 
			@create_purchase_unit = false
			@name = line_item.style_name
			@sku = CustomItemSku.new(line_item).call
			@base_price = line_item.price.to_f
			@units_of_measure = 1
			@units_of_measure_type_id = get_measurement_type_id_by_name('Piece')
			@weight = 3.0
			@shipping_units_of_measure_type_id = 1
			@taxable = true #Assume everything is taxable it is dependent on where the order is from
			@min_quantity = 1
			@active = true
			@is_parent = false
			@upc = GlobalSku.find_by_product_id(product.id).upc
			@country_of_product = 'CN'

# 			[{
# 	"reference_product_id": 1397,
# 	"group_id": 19990,
# 	"name": "The Jennifer",
# 	"description": "TestAPIProduct",
# 	"sku": "fp2212s2f3",
# 	"base_price": 258.0,
# 	"units_of_measure": 1, 
# 	"units_of_measure_type_id": 3297,
# 	"weight": 3,
# 	"shipping_units_of_measure_type_id": 1,
# 	"taxable": false,
# 	"min_quantity": 1,
# 	"active": true,
# 	"upc": "1234",
# 	"create_bom": false,
# 	"create_purchase_unit": false
# }]
		end
		
	end
end