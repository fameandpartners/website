include Spree::OrderBotHelper
module OrderBot
	class Order

		def initialize(order, line_items)
			order_bot_factory_hash = {
				'Zhesi' => 'INTEX',
				'Milly' => 'ANYUYANG',
				'Supertex' => 'SUPERTEX',
				'Elizabeth' => 'ELIZABETH'
			}
			first_line_item = line_items.first
			adjustments = per_item_adjustment(line_items, order).to_f
			@reference_order_id = order.number + '-' + line_items.map(&:id).join('-')
			@order_date	= order.created_at
			@orderbot_account_id = 2
			@account_group_id = 1132
			@orderbot_customer_id = get_customer_id(order.bill_address.country.iso)
			@ship_date = first_line_item.delivery_period_policy.ship_by_date(order.completed_at, first_line_item.delivery_period)
			@billing_third_party = false
			@insure_packages = false #Dont do insurance
			@shipping_code = order.shipping_method.name
			@subtotal = line_items.inject(0){|sum, item| sum + item.price}
			@order_status = 'unconfirmed'
			@shipping = 0 #TODO: Revist this. We currently bake in the shipping cost.
			@order_total = (((adjustments) * line_items.count) + @subtotal)
			@order_discount = per_item_discount_adjustment(line_items, order).abs * line_items.count
			@shipping_address = OrderBot::ShippingAddress.new(order.ship_address)
			@billing_address = OrderBot::BillingAddress.new(order.bill_address)			
			@order_lines = generate_order_lines(line_items, order)
			@other_charges = generate_other_charges(per_item_shipping_adjustment(line_items, order))
			@internal_notes = check_for_special_care(order)
			@order_notes = @reference_order_id
			@distribution_center_id = get_distribution_center(order_bot_factory_hash[first_line_item.product.factory.name])

		end

		def check_for_special_care(order)
			promos = order&.promotions
			vip_labels = ['CINFGW', 'CVIPGQ', 'CSG']
			
			if promos
				special_care =  promos.select {|promo| vip_labels.any?{ |vip_label| promo.code.upcase.include?(vip_label)}}
				unless special_care.empty?
					'VIP ORDER - EXTRA CARE REQUIRED'
				end
			end
		end
 #OrderBot::Order.new(@order,@order.line_items)
		private

		def generate_order_lines(line_items, order)
			h = Hash.new { |hash, key| hash[key] = 0}
			line_items.each do |item| 
				if item.personalization
					h[item.personalization.sku] = h[item.personalization.sku] += 1
				else
					h[item.variant.sku] = h[item.variant.sku] += 1
				end
			end

		 	line_array = []
			h.each_pair do |sku, quantity|
				l_i = line_items.select {|item| (item.personalization.nil? && item.variant.sku == sku) || (item.personalization && item.personalization.sku == sku)}.first
				line_array << OrderBot::OrderLine.new(l_i, order, quantity)
			end

			line_array
		end

		def generate_other_charges(adjustments)
			[{'other_charge_id' => 1, 'amount' => adjustments}]
		end

		def per_item_shipping_adjustment(line_items, order)
			shipping = order&.adjustments&.shipping&.inject(0){|sum, item| sum + item.amount.abs}
			shipping/line_items.count
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

		def per_item_discount_adjustment(line_items, order)
			discount = order&.adjustments&.promotion&.inject(0){|sum, item| sum + item.amount.abs}
			manual_order_adjustment = order&.adjustments.select {|o| o.label.downcase.include?('exchange') ||o.label.downcase.include?('manual')}
			discount += manual_order_adjustment.inject(0){|sum, item| sum + item.amount.abs}
			discount/order.line_items.count
		end
 		
 		def per_item_tax_free_adjustment(total_tax, line_items, order)
		    ((order.adjustment_total - total_tax) / line_items.count)
	    end
	end
end
# sync_yesterdays_order_updates
# include Spree::OrderBotHelper 
# @order = Spree::Order.find_by_number('R427516377')
# create_new_order_by_factory(order)

