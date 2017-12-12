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
			if first_line_item.product.name.downcase == 'return_insurance'
				adjustments = 0
			else
				adjustments = per_item_adjustment(line_items, order).to_f
			end
			@reference_order_id = order.number + '-' + line_items.map(&:id).join('-')
			@order_date	= order.completed_at
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
			@shipping_address = OrderBot::ShippingAddress.new(order.ship_address)
			@billing_address = OrderBot::BillingAddress.new(order.bill_address)			
			@order_lines = generate_order_lines(line_items, order)
			@other_charges = generate_other_charges(per_item_shipping_adjustment(line_items, order))
			@internal_notes = check_for_special_care(order)
			@order_notes = generate_tag_description(line_items)
			unless first_line_item.product.name.downcase == 'return_insurance'
				@order_discount = per_item_discount_adjustment(line_items, order).abs * line_items.count
				@distribution_center_id = get_distribution_center(order_bot_factory_hash[first_line_item.product.factory.name])
			end

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

		private

		 def generate_tag_description(line_items)
		 	item_description_array = []
		 	line_items.each do |line_item|
			 	item_description_array << "Name: #{line_item.product.name}"
			 	item_description_array << "Style Number: #{GlobalSku.find_by_product_id(line_item.product.id).style_number}"
				unless line_item.personalization.nil?
					line_item.personalization.options_hash.each_pair do |key, value| #size and color
						unless value.nil?
							item_description_array << "#{key}: #{value}"
						end
					end

					line_item.personalization.customization_values.each do |customization| #customizations
						item_description_array << "Customization: #{customization.presentation}"
					end

					item_description_array << "Height: #{line_item.personalization.height}"
				end
				item_description_array << "\n"
			end
			item_description_array.join("\n")
	    end

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
			(shipping/order.line_items.count) *line_items.count
		end

		def per_item_adjustment(line_items, order)
			# deal with tax adjustments'
			line_item_taxes = per_item_tax_adjustment(line_items)

			order_taxes = per_item_tax_adjustment(order.line_items.reject{|x| x.product.name.downcase == 'return_insurance'})

			# deal with all other adjustments
			splittable_adjustment = per_item_tax_free_adjustment(order_taxes['total_tax'], order.line_items.reject{|x| x.product.name.downcase == 'return_insurance'}, order)

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
			promotion_action_ids = order.promotions.map {|x| x.promotion_actions&.first&.id }
			promotions = order&.adjustments&.promotion&.eligible&.select {|x| promotion_action_ids.include?(x.originator_id)}
			promotions = promotions&.uniq {|x| x.label}
			discount = 0
			if promotions
				discount += promotions.inject(0){|sum, item| sum + item.amount.abs}
			end
			manual_order_adjustment = order&.adjustments.select {|o| o.label.downcase.include?('exchange') ||o.label.downcase.include?('manual')}
			discount += manual_order_adjustment.inject(0){|sum, item| sum + item.amount.abs}
			discount/order.line_items.reject{|x| x.product.name.downcase == 'return_insurance'}.count
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

