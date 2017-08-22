module OrderBot
	class Order

		def initialize(order, line_items)
			splitter = ItemPriceAdjustmentSplit.new(line_items.first)
			adjustments = splitter.per_item_adjustment_in_cents/100.0
			@reference_order_id = order.id
			@order_date	= order.created_at
			@orderbot_account_id = 2
			@account_group_id = 755
			@orderbot_customer_id = 1
			@ship_date = order.projected_delivery_date #NOT CORRECT NEED TO MODIFY
			@billing_third_party = false
			@insure_packages = false #Dont do insurance
			@shipping_code = order.shipping_method.name
			@subtotal = line_items.inject(0){|sum, item| sum + item.price}
			@order_status = 'unconfirmed'
			@shipping = 0 #TODO: Revist this. We currently bake in the shipping cost.
			@order_total = ((adjustments) * line_items.count) + @subtotal
			@shipping_address = OrderBot::ShippingAddress.new(order.ship_address)
			@billing_address = OrderBot::BillingAddress.new(order.bill_address)
			@order_lines = generate_order_lines(line_items, order)
			@other_charges = generate_other_charges(adjustments)
		end

		def generate_order_lines(line_items, order)
			line_items.map do |line_item|
				OrderBot::OrderLine.new(line_item, order)
			end
		end

		def generate_other_charges(adjustments)
			[{'other_charge_id' => 1, 'amount' => adjustments}]
		end

	    def split_order(order)

    	end
	end
end
# include Spree::OrderBotHelper
# @order = Spree::Order.find(35424843)
# create_new_order(@order)