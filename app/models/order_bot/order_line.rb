module OrderBot
	class OrderLine

		def initialize(line_item, order)			splitter = ItemPriceAdjustmentSplit.new(line_item)
			@line_number = line_item.id
			@product_sku = CustomItemSku.new(line_item).call
			@quantity = line_item.quantity			
			@product_taxes = generate_taxes(line_item, order)
			@discount = splitter.per_item_discounts_in_cents.to_f/100
			@price = line_item.price - @discount
		end

		def generate_taxes(line_item, order)
		    tax_adj = order&.adjustments&.tax&.first

		    unless tax_adj.nil?
		    	tax_rate = Spree::TaxRate.find(tax_adj.originator_id)	    
			    unless tax_rate.nil?
			    	splitter = ItemPriceAdjustmentSplit.new(line_item)
					
					[{'tax_name' => "Tax", 'tax_rate' => tax_rate.amount, 'amount' => splitter.per_item_tax_adjustment_in_cents.to_f/100}]
				else
					[]
				end
			else
				[]
			end

		end
	end
end