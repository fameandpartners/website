module OrderBot
	class Order

		def initialize(order, line_items)
			splitter = ItemPriceAdjustmentSplit.new(line_items.first)
			@reference_order_id = order.id
			@order_date	= order.created_at
			@ship_date = order.projected_delivery_date #NOT CORRECT NEED TO MODIFY
			@billing_third_party = false
			@insure_packages = false #Dont do insurance
			@shipping_code = order.shipping_method.name
			@subtotal = 
			@shipping = 0 #TODO: Revist this. We currently bake in the shipping cost.
			binding.pry
			@order_total = (splitter.per_item_adjustment_in_cents * line_items.count) + @subtotal
			@shipping_address = OrderBot::ShippingAddress.new(order.ship_address)
			@billing_address = OrderBot::BillingAddress.new(order.bill_address)
			@order_lines = generate_order_lines(line_items, order)
		end

		def generate_order_lines(line_items, order)
			line_items.map do |line_item|
				OrderBot::OrderLine.new(line_item, order)
			end
		end
	end
end
# @order = Spree::Order.find(35424843) This is for personal use ignore will delete before merging