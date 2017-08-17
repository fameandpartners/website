module OrderBot
	class Order

		def initialize(order, line_items)
			@reference_order_id = order.id
			@order_date	= order.created_at
			@ship_date = order.projected_delivery_date #NOT CORRECT NEED TO MODIFY
			@billing_third_party = false
			@insure_packages = false #Dont do insurance
			@shipping_code = 1234 #TODO: Look into this
			@subtotal = line_items.inject(0){|sum, item| sum + item.price}
			@shipping = 0 #TODO: Revist
			@order_total = 0 #TODO: After merge use item_price_adjustment
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
# @order = Spree::Order.find(35424845) This is for personal use ignore will delete before merging
