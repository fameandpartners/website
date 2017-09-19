module OrderBot
	class BillingAddress

		def initialize(billing_address)
			@account_name = "#{billing_address.firstname} #{billing_address.lastname}"
			@first_name = ""
			@last_name	= ""
			@store_name = "" #NOT CORRECT NEED TO MODIFY
			@address1 = billing_address.address1
			@address2 = billing_address.address2.blank? ? nil : billing_address.address2 
			@phone_number = billing_address.phone
			@city = billing_address.city
			@state = billing_address&.state&.abbr ||  billing_address.state_name
			@postal_code = billing_address.zipcode
		    @country = billing_address.country.iso
		end
	end
end