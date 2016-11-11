require "base64"
require "digest"
require "openssl"

module Iequalchange
  class Encrypt
    ALGORITHM = 'aes-256-cbc'.freeze
    PREFIX  = 'iEC'.freeze
    VERSION = 2.chr.freeze

    def self.process(order)
      ::Iequalchange.configure( 
        iec_id:  ENV.fetch('IEC_ID',  ::Iequalchange.config.iec_id),
        iec_key: ENV.fetch('IEC_KEY', ::Iequalchange.config.iec_key)
      )

      billing_adress = order.billing_address
      address_info =
        if billing_adress.present?
          {
            first_name:      address_info.firstname,
            surname:         address_info.lastname,
            postcode:        address_info.zipcode,
            state:           address_info.state_text,
            country:         address_info.country.iso_name
          }
        else
          {}
        end

      order_data = {
        orderid:         order.number,
        totalamount:     order.item_total,
        customer_email:  order.email,
        customer_id:     order.user_id.presence || 'Guest Checkout'
      }

      iec_json_data = order_data.merge(address_info).to_json
      iec_site_key = ::Iequalchange.config.iec_key

      iec_encrypted_data = encode(iec_site_key, iec_json_data)

      iec_site_src = ::Iequalchange.config.iec_url + 'static/js/load'
      safe_iec_site = URI.escape(iec_site_src)
      safe_site_url = URI.escape(::Iequalchange.config.iec_url)
      safe_site_id = ::Iequalchange.config.iec_id

      {
        url: safe_site_url,
        site: safe_iec_site,
        id: safe_site_id,
        data: iec_encrypted_data
      }
    end

    private
    def self.encode(key, payload)
      cipher = OpenSSL::Cipher::Cipher.new(ALGORITHM)
      cipher.encrypt
      cipher.key = Digest::SHA256.new.digest(key)

      encrypted = [cipher.update(payload), cipher.final].join
      final_payload = [PREFIX, VERSION, cipher.random_iv, encrypted].join

      Base64.strict_encode64(final_payload)
    end
  end
end
