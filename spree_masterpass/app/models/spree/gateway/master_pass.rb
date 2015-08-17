require 'mastercard_masterpass_api'
module Spree
  class Gateway::MasterPass < Gateway
    preference :consummer_key, :string
    preference :checkeout_identifier, :string

    preference :server, :string, default: 'sandbox'

    def supports?(source)
      true
    end

    def provider_class
      self.class
    end

    def provider
      @keystore_path = ''
      @keystore_password = ''
      @callback_domain = Spree::Config.site_url
      @pairing_callback_path = '/mp_pairingcallback'
      @express_callback_path = '/mp_pairingcallback?express=true'
      @cart_callback_path = '/mp_cartcallback'
      @connected_callback_path = '/mp_oauthcallback?connect=true'
      @callback_path = '/mp_oauthcallback'


      @shipping_profiles = 'US,CA,FR,MEX,NA,UK'
      @realm = 'eWallet'
      @allowed_loyalty_programs = [4878508, 4735583]
      @xml_version = 'v2'
      @shipping_suppression = false
      @auth_level_basic = false

      if (server == 'sandbox' || !Rails.env.production?)
        @request_url = 'https://sandbox.api.mastercard.com/oauth/consumer/v1/request_token'
        @shopping_cart_url = 'https://sandbox.api.mastercard.com/mtf/masterpass/v6/shopping-cart'
        @access_url = 'https://sandbox.api.mastercard.com/oauth/consumer/v1/access_token'
        @postback_url = 'https://sandbox.api.mastercard.com/mtf/masterpass/v6/transaction'
        @pre_checkout_url = 'https://sandbox.api.mastercard.com/mtf/masterpass/v6/precheckout'
        @express_checkout_url = 'https://sandbox.api.mastercard.com/masterpass/v6/expresscheckout'
        @merchant_init_url = 'https://sandbox.api.mastercard.com/masterpass/v6/merchant-initialization'
        @checkout_url = 'https://sandbox.api.mastercard.com/mtf/masterpass/v6/checkout'
        @lightbox_url = 'https://sandbox.masterpass.com/lightbox/Switch/integration/MasterPass.client.js'
        @omniture_url = 'https://sandbox.masterpass.com/lightbox/Switch/assets/js/MasterPass.omniture.js'

        @provider ||= Mastercard::Masterpass::MasterpassService.new(consumer_key, generate_private_key, Spree::Config.site_url, Mastercard::Common::SANDBOX)
      else
        @shopping_cart_url = 'https://api.mastercard.com/mtf/masterpass/v6/shopping-cart'
        @request_url = 'https://api.mastercard.com/oauth/consumer/v1/request_token'
        @access_url = 'https://api.mastercard.com/oauth/consumer/v1/access_token'
        @postback_url = 'https://api.mastercard.com/mtf/masterpass/v6/transaction'
        @pre_checkout_url = 'https://api.mastercard.com/mtf/masterpass/v6/precheckout'
        @express_checkout_url = 'https://api.mastercard.com/masterpass/v6/expresscheckout'
        @merchant_init_url = 'https://api.mastercard.com/masterpass/v6/merchant-initialization'
        @checkout_url = 'https://api.mastercard.com/mtf/masterpass/v6/checkout'
        @lightbox_url = 'https://mtf.masterpass.com/lightbox/Switch/integration/MasterPass.client.js'
        @omniture_url = 'https://sandbox.masterpass.com/lightbox/Switch/assets/js/MasterPass.omniture.js'

        @provider ||= Mastercard::Masterpass::MasterpassService.new(consumer_key, generate_private_key, Spree::Config.site_url, Mastercard::Common::PRODUCTION)
      end
    end

    def setup
      @service = Mastercard::Masterpass::MasterpassService.new(@data.consumer_key, generate_private_key, @data.callback_domain, Mastercard::Common::SANDBOX)
      # create an unreferenced MasterpassDataMapper to include the mapping namespaces of our DTO's
      MasterpassDataMapper.new
    end

    def generate_private_key
      OpenSSL::PKCS12.new(File.open(keystore_path),keystore_password).key
    end

    def auto_capture?
      true
    end

    def method_type
      'masterpass'
    end

    def purchase(amount, express_checkout, gateway_options={})

    end
  end
end