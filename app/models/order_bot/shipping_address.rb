module OrderBot
	class ShippingAddress

		def initialize(shipping_address)
			@first_name = shipping_address.firstname
			@last_name	= shipping_address.lastname
			@store_name = "" #NOT CORRECT NEED TO MODIFY
			@address1 = shipping_address.address1
			@address2 = shipping_address.address2 
			@city = shipping_address.city
			@state = shipping_address.state.abbr
			@postal_code = shipping_address.zipcode
		    @country = shipping_address.country.iso
		end
	end
end