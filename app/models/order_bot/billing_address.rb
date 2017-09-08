module OrderBot
	class BillingAddress

		def initialize(billing_address)
			@first_name = billing_address.firstname
			@last_name	= billing_address.lastname
			@store_name = "" #NOT CORRECT NEED TO MODIFY
			@address1 = billing_address.address1
			@address2 = billing_address.address2 
			@city = billing_address.city
			@state = billing_address.state.abbr
			@postal_code = billing_address.zipcode
		    @country = billing_address.country.iso
		end
	end
end