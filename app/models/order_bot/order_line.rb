module OrderBot
	class OrderLine

		def initialize(line_item)
			@line_number = line_item.id
			@product_sku = line_item.variant.sku
			@quantity = line_item.quantity
			@price = line_item.price
			@product_taxes = generate_taxes(line_item)
		end

		def generate_taxes(line_item)
			[{'tax_name' => 'TAX', 'tax_rate' => 0.05, 'amount' => 0.54}]
		end
	end
end