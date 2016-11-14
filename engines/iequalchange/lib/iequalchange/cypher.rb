require "base64"
require "digest"
require "openssl"

module Iequalchange
  class Cypher
    ALGORITHM = 'aes-256-cbc'.freeze
    PREFIX  = 'iEC'.freeze
    VERSION = 2.chr.freeze

    SCRIPT_SRC_PATH = 'static/js/load'.freeze

    attr_reader :order, :cipher

    def initialize(order)
      @order  = order
      @cipher = OpenSSL::Cipher::Cipher.new(ALGORITHM)

      ::Iequalchange.configure(
        iec_id:  ENV.fetch('IEC_ID',  ::Iequalchange.config.iec_id),
        iec_key: ENV.fetch('IEC_KEY', ::Iequalchange.config.iec_key)
      )
    end

    def encode
      json_data = order_to_json(order)

      encrypted = encrypt(json_data)
      final_payload = [PREFIX, VERSION, cipher.random_iv, encrypted].join

      payload = Base64.strict_encode64(final_payload)
      script_src = [::Iequalchange.config.iec_url, SCRIPT_SRC_PATH].join

      {
        id:  ::Iequalchange.config.iec_id,
        url: URI.escape(::Iequalchange.config.iec_url),
        src: URI.escape(script_src),
        payload: payload
      }
    end

    def self.decode(payload)
      str = Base64.decode64(payload)
      instance = self.new(nil)

      match_data = str.match(/#{PREFIX}#{VERSION}(?<iv>.{#{instance.cipher.iv_len}})(?<data>[\S\s]+)/)

      if instance.cipher.iv_len == match_data['iv'].length
        JSON.parse(
          instance.send(:decrypt, match_data['data'])
        )
      else
        raise StandardError, 'incorrect iv for payload'
      end
    end

    private

    def encrypt(json)
      key = ::Iequalchange.config.iec_key

      cipher.encrypt
      cipher.key = Digest::SHA256.new.digest(key)

      [cipher.update(json), cipher.final].join
    end

    def decrypt(encoded_str)
      key = ::Iequalchange.config.iec_key

      cipher.decrypt
      cipher.key = Digest::SHA256.new.digest(key)

      [cipher.update(encoded_str), cipher.final].join
    end

    def order_to_json(order)
      billing_adress = order.billing_address

      address_info = \
        if billing_adress.present?
          {
            firstname:  billing_adress.firstname,
            surname:    billing_adress.lastname,
            postcode:   billing_adress.zipcode,
            state_text: billing_adress.state_text,
            country_iso_name: billing_adress.country.iso_name
          }
        else
          {}
        end

      order_data = {
        :orderid        => order.number,
        :totalamount    => order.item_total,
        :customer_email => order.email,
        :first_name     => address_info.fetch(:firstname, nil),
        :surname        => address_info.fetch(:lastname, nil),
        :customer_id    => order.user_id.presence || 'Guest Checkout',
        :postcode       => address_info.fetch(:zipcode, nil),
        :state          => address_info.fetch(:state_text, nil),
        :country        => address_info.fetch(:country_iso_name, nil),
      }

      order_data.merge(address_info).to_json
    end
  end
end
