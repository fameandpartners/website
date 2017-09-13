require 'securerandom' 
module OrderBot
	class Order

		def initialize(order, line_items)
			tax_free_adjustments = per_item_tax_free_adjustment_two_param(order.line_items, order).to_f
			adjustments = per_item_adjustment(line_items, order).to_f
			@reference_order_id = order.number + SecureRandom.uuid
			@order_date	= order.created_at
			@orderbot_account_id = 2
			@account_group_id = 755
			@orderbot_customer_id = 1
			@ship_date = order.projected_delivery_date - 4.days
			@billing_third_party = false
			@insure_packages = false #Dont do insurance
			@shipping_code = order.shipping_method.name
			@subtotal = line_items.inject(0){|sum, item| sum + item.price}
			@order_status = 'unconfirmed'
			@shipping = 0 #TODO: Revist this. We currently bake in the shipping cost.
			@order_total = (((adjustments) * line_items.count) + @subtotal)
			@shipping_address = OrderBot::ShippingAddress.new(order.ship_address)
			@billing_address = OrderBot::BillingAddress.new(order.bill_address)
			@order_lines = generate_order_lines(line_items, order)
			@other_charges = generate_other_charges((tax_free_adjustments* line_items.count)) #This should add or subtract the rounding errors as other amounts
		end

		private

		def generate_order_lines(line_items, order)
			line_items.map do |line_item|
				OrderBot::OrderLine.new(line_item, order)
			end
		end

		def generate_other_charges(adjustments)
			[{'other_charge_id' => 1, 'amount' => adjustments}]
		end

		def per_item_adjustment(line_items, order)
			# deal with tax adjustments
			line_item_taxes = per_item_tax_adjustment(line_items)

			order_taxes = per_item_tax_adjustment(order.line_items)

			# deal with all other adjustments
			splittable_adjustment = per_item_tax_free_adjustment(order_taxes['total_tax'], order.line_items, order)

			(line_item_taxes['total_tax']/line_items.count) + splittable_adjustment
		end

		def per_item_tax_adjustment (line_items)    
			tax_adj = line_items.first.order&.adjustments&.tax&.first
			item_tax = 0
			total_tax = 0

			if tax_adj
			  tax_rate = Spree::TaxRate.find(tax_adj.originator_id).amount

			  total_tax = line_items.inject(0) do |total, li|
			    total + ((((li.price*100).to_i * tax_rate) / 100.0))
			  end
			  total_tax = total_tax.round(2)
			end

			{ 'total_tax' => total_tax }
		end

		def per_item_tax_free_adjustment_two_param(line_items,order)
			per_item_tax_free_adjustment(per_item_tax_adjustment(line_items)['total_tax'], line_items, order)
		end

		def per_item_discount_adjustment(line_items)
			discount = line_items.first.order&.adjustments&.promotion&.inject(0){|sum, item| sum + item.amount.abs}
			discount/line_items.count
		end
 		
 		def per_item_tax_free_adjustment(total_tax, line_items, order)
		    ((order.adjustment_total - total_tax) / line_items.count)
	    end
	end
end
# include Spree::OrderBotHelper
# @order = Spree::Order.find(35425104)
# create_new_order_by_factory(@order)
