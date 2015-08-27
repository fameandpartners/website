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

    KEYSTORE_INFO = {
        :sandbox => {
            :path => 'spree_masterpass/resources/Certs/SandMCOpenAPI.p12',
            :password => 'WIX8CDD/tR'
        },
        :live => {
            :path => 'spree_masterpass/resources/Certs/MCOpenAPI.p12',
            :password => '22qPm/TsUE'
        }
    }
    REQUEST_URL = {
        :sandbox => 'https://sandbox.api.mastercard.com/oauth/consumer/v1/request_token',
        :live => 'https://api.mastercard.com/oauth/consumer/v1/request_token'
    }
    ACCESS_URL = {
        :sandbox => 'https://sandbox.api.mastercard.com/oauth/consumer/v1/access_token',
        :live => 'https://api.mastercard.com/oauth/consumer/v1/access_token'
    }
    SHOPPING_CART_URL = {
        :sandbox => 'https://sandbox.api.mastercard.com/masterpass/v6/shopping-cart',
        :live => 'https://api.mastercard.com/masterpass/v6/shopping-cart'
    }
    POSTBACK_URL = {
        :sandbox => 'https://sandbox.api.mastercard.com/masterpass/v6/transaction',
        :live => 'https://api.mastercard.com/masterpass/v6/transaction'
    }

    def keystore
      preferred_server.present? && preferred_server == 'live' ?
          Spree::Gateway::Masterpass::KEYSTORE_INFO[:live] :
          Spree::Gateway::Masterpass::KEYSTORE_INFO[:sandbox]
    end

    def request_url
      preferred_server.present? && preferred_server == 'live' ? REQUEST_URL[:live] : REQUEST_URL[:sandbox]
    end

    def access_url
      preferred_server.present? && preferred_server == 'live' ? ACCESS_URL[:live] : ACCESS_URL[:sandbox]
    end

    def shopping_cart_url
      preferred_server.present? && preferred_server == 'live' ? SHOPPING_CART_URL[:live] : SHOPPING_CART_URL[:sandbox]
    end

    def postback_url
      preferred_server.present? && preferred_server == 'live' ? POSTBACK_URL[:live] : POSTBACK_URL[:sandbox]
    end

    def callback_domain
      Spree::Config[:site_url]
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

    def payment_profiles_supported?
      true
    end

    def purchase(amount, express_checkout, gateway_options={})
      test = 'test'
    end

    def refund(payment, amount)

    end
  end
end