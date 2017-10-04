module OrderBot
	class OrderLine

		def initialize(line_item, order, quantity)
			splitter = ItemPriceAdjustmentSplit.new(line_item)
			@line_number = line_item.id
			@product_sku = CustomItemSku.new(line_item).call
			@quantity = quantity			
			@product_taxes = generate_taxes(line_item, order, quantity)
			@discount = per_item_discount_adjustment(order) * quantity

			@price = line_item.price
		end

		def generate_taxes(line_item, order, quantity)
		    tax_adj = order&.adjustments&.tax&.first

		    unless tax_adj.nil?
		    	tax_rate = Spree::TaxRate.find(tax_adj.originator_id)	    
			    unless tax_rate.nil?

					[{'tax_name' => "Tax", 'tax_rate' => tax_rate.amount, 'amount' => (line_item.price - per_item_discount_adjustment(order)) * tax_rate.amount * quantity}]
				else
					[]
				end
			else
				[]
			end

		end

		def per_item_discount_adjustment(order)
			promotion_action_ids = order.promotions.map {|x| x.promotion_actions&.first&.id }
			promotions = order&.adjustments&.promotion&.eligible&.select {|x| promotion_action_ids.include?(x.originator_id)}
			promotions = promotions&.uniq {|x| x.label}
			discount = 0
			if promotions
				discount += promotions.inject(0){|sum, item| sum + item.amount.abs}
			end
			manual_order_adjustment = order&.adjustments.select {|o| o.label.downcase.include?('exchange') ||o.label.downcase.include?('manual')}
			discount += manual_order_adjustment.inject(0){|sum, item| sum + item.amount.abs}
			discount/order.line_items.count
		end

	end
end