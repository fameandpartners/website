module OrderBot
	class OrderLine

		def initialize(line_item, order)
			splitter = ItemPriceAdjustmentSplit.new(line_item)
			@line_number = line_item.id
			@product_sku = CustomItemSku.new(line_item).call
			@quantity = line_item.quantity			
			@product_taxes = generate_taxes(line_item, order)
			@discount = per_item_discount_adjustment(order)

			@price = line_item.price
		end

		def generate_taxes(line_item, order)
		    tax_adj = order&.adjustments&.tax&.first

		    unless tax_adj.nil?
		    	tax_rate = Spree::TaxRate.find(tax_adj.originator_id)	    
			    unless tax_rate.nil?

					[{'tax_name' => "Tax", 'tax_rate' => tax_rate.amount, 'amount' => (line_item.price - per_item_discount_adjustment(order))* tax_rate.amount}]
				else
					[]
				end
			else
				[]
			end

		end

		def per_item_discount_adjustment(order)
			discount = order&.adjustments&.promotion&.inject(0){|sum, item| sum + item.amount.abs}
			discount/order.line_items.count
		end

	end
end