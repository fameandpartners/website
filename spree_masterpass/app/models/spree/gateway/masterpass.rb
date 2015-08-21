require 'mastercard_masterpass_api'
module Spree
  class Gateway::Masterpass < Gateway
    preference :consumer_key, :string
    preference :checkout_identifier, :string
    preference :accepted_cards, :string, default: 'master,amex,diners,discover,maestro,visa'
    preference :shipping_suppression, :boolean, default: true
    preference :server, :string, default: 'sandbox'

    attr_accessible :preferred_consumer_key, :preferred_checkout_identifier, :preferred_accepted_cards,
                    :preferred_shipping_suppression, :preferred_server

    KEYSTORE_PATH = 'spree_masterpass/resources/Certs/SandboxMCOpenAPI.p12'
    KEYSTORE_PASSWORD = 'changeit'

    def callback_domain
      Spree::Config[:site_url]
    end

    def request_url
      'https://sandbox.api.mastercard.com/oauth/consumer/v1/request_token'
    end

    def access_url
      'https://sandbox.api.mastercard.com/oauth/consumer/v1/access_token'
    end

    def shopping_cart_url
      'https://sandbox.api.mastercard.com/masterpass/v6/shopping-cart'
    end

    def supports?(source)
      true
    end

    def provider_class
      self.class
    end

    def provider
      provider_class.new
    end

    def auto_capture?
      true
    end

    def method_type
      'masterpass'
    end

    def purchase(amount, express_checkout, gateway_options={})

    end

    def refund(payment, amount)

    end

    def generate_private_key
      OpenSSL::PKCS12.new(File.open(KEYSTORE_PATH),KEYSTORE_PASSWORD).key
    end

    def service
      Mastercard::Masterpass::MasterpassService.new(preferred_consumer_key, generate_private_key, callback_domain, Mastercard::Common::SANDBOX)
    end

    def get_request_token
      service.get_request_token(request_url, callback_domain)
    end

    def get_shopping_cart_response(shopping_cart_request)
      service.post_shopping_cart_data(shopping_cart_url, shopping_cart_request.to_xml_s)
    end

    def get_access_token(request_token, verifier)
      service.get_access_token(access_url, request_token, verifier)
    end

    def get_payment_shipping_resource(checkout_resource_url, access_token)
      service.get_payment_shipping_resource(checkout_resource_url, access_token)
    end

    def get_long_access_token(pairing_token, pairing_verifier)
      service.get_long_access_token(access_url, pairing_token, pairing_verifier)
    end
  end
end