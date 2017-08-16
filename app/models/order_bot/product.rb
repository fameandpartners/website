module OrderBot
	class Product
		include Spree::OrderBotHelper

		def initialize(line_item)
			product = line_item.product
			@reference_product_id = product.id # This is going to need to change
			@group_id = get_group_id_by_product(1234) # Need to check on this
			@create_bom = false 
			@create_purchase_unit = false
			@name = product.name
			@sku = line_item.variant.sku
			@base_price = line_item.price
			@units_of_measure = 'Piece'
			@units_of_measure_type_id = get_measurement_type_id_by_name('Piece')
			@weight = 3.0
			@shipping_units_of_measure_type_id = get_measurement_type_id_by_name('Lbs')
			@taxable = true #Check and make item is taxable
			@min_quantity = 1
			@active = true
			@is_parent = false

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