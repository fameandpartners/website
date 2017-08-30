module OrderBot
	class OrderLine

		def initialize(line_item, order)
			@line_number = line_item.id
			@product_sku = CustomItemSku.new(line_item).call
			@quantity = line_item.quantity
			@price = line_item.price
			@product_taxes = generate_taxes(line_item, order)
		end

		def generate_taxes(line_item, order)
			tax_adj =order&.adjustments&.tax&.first
		    item_tax = 0
		    total_tax = 0
		    binding.pry
		    tax_rate = Spree::TaxRate.find(tax_adj.originator_id)
		    
		    unless tax_rate.nil?
				[{'tax_name' => tax_rate.name, 'tax_rate' => tax_rate.amount, 'amount' => line_item.price * tax_rate.amount}]
			else
				[]
			end

		end
	end
end