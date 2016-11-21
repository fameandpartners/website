require "base64"
require "digest"
require "openssl"

module Iequalchange
  class Cypher
    ALGORITHM = 'aes-256-cbc'.freeze
    PREFIX  = 'iEC'.freeze
    VERSION = 2.chr.freeze

    attr_reader :order, :cipher, :config

    def initialize(order)
      @order  = order
      @cipher = OpenSSL::Cipher::Cipher.new(ALGORITHM)
      @config = ::Iequalchange::Config.new.config
    end

    def encode
      json_data = order_to_json(order)
      iv = cipher.random_iv

      encrypted = encrypt(json_data)

      final_payload = PREFIX + VERSION + iv + encrypted

      payload = Base64.strict_encode64(final_payload)
      script_src = [config[:url], config[:script_src_path]].join

      {
        id:  config[:id],
        url: URI.escape(config[:url]),
        src: URI.escape(script_src),
        payload: payload
      }
    end

    def self.decode(payload)
      str = Base64.decode64(payload)
      instance = self.new(nil)
      iv_length = instance.cipher.iv_len

      match_data = str.match(/#{PREFIX}#{VERSION}(?<iv>.{#{iv_length}})(?<data>[\S\s]+)/)

      if iv_length == match_data['iv'].length
        decrypted = instance.send(:decrypt, match_data['iv']+match_data['data'])
        decrypted.gsub!(/^.{#{iv_length}}/, '') if decrypted[0] != '{'

        JSON.parse(decrypted)
      else
        raise StandardError, 'incorrect iv for payload'
      end
    end

    private

    def encrypt(json)
      cipher.encrypt
      cipher.key = Digest::SHA256.new.digest(config[:key])

      cipher.update(json) + cipher.final
    end

    def decrypt(encoded_str)
      key = config[:key]

      cipher.decrypt
      cipher.key = Digest::SHA256.new.digest(key)

      cipher.update(encoded_str) + cipher.final
    end

    def order_to_json(order)
      billing_adress = order.billing_address

      address_info = \
        if billing_adress.present?
          {
            firstname:  billing_adress.firstname,
            lastname:   billing_adress.lastname,
            zipcode:    billing_adress.zipcode,
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

      order_data.merge(order_data).to_json
    end
  end
end
