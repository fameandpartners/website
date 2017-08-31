module OrderBot
	class OrderLine

		def initialize(line_item, order)

			@line_number = line_item.id
			@product_sku = CustomItemSku.new(line_item).call
			@quantity = line_item.quantity			
			@product_taxes = generate_taxes(line_item, order)
			@price = line_item.price
		end

		def generate_taxes(line_item, order)
		    tax_adj = order&.adjustments&.tax&.first
		    tax_rate = Spree::TaxRate.find(tax_adj.originator_id)
		    
		    unless tax_rate.nil?
		    	splitter = ItemPriceAdjustmentSplit.new(line_item)
				
				[{'tax_name' => "Tax", 'tax_rate' => tax_rate.amount, 'amount' => splitter.per_item_tax_adjustment_in_cents.to_f/100}]
			else
				[]
			end

		end
	end
end