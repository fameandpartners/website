module Spree
	Order.class_eval do
		def payload
			iec_settings = Spree::DonationConfiguration.new

			if !iec_settings[:enabled]
				return
			end

			user_id = self.user_id

			if user_id.blank?
				user_id = 'Guest Checkout'
			end

			address_info = Spree::Address.where(:id => self.bill_address_id).first
			iec_data = {
				:orderid        => self.number,
				:totalamount    => self.item_total,
				:customer_email => self.email,
				:first_name     => address_info.firstname,
				:surname        => address_info.lastname,
				:customer_id    => user_id,
				:postcode       => address_info.zipcode,
				:state          => address_info.state_text,
				:country        => address_info.country.iso_name,
			}

			iec_site_key = iec_settings[:site_key]

        	iec_secure = IEqualChange::SecureTransport.new(iec_site_key)

        	iec_encrypted_data = iec_secure.encrypt(iec_data.to_json)
			iec_site_src = iec_settings[:site_url] + 'static/js/load'
			safe_iec_site = URI.escape(iec_site_src)
			safe_site_url = URI.escape(iec_settings[:site_url])
			safe_site_id = iec_settings[:site_id]

			html_code = "<script src='#{safe_iec_site}'"\
						" data-iec-location='#{safe_site_url}'"\
						" data-site-id='#{safe_site_id}'"\
						" data-payload='#{iec_encrypted_data}'"\
						"></script>"\
						"<script>"\
						"iec('#{safe_site_url}',"\
						"'#{safe_site_id}',"\
						"'#{iec_encrypted_data}');"\
						"</script>"


			return html_code
		end
	end
end