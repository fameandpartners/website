require "mastercard_api"
require "rexml/document"

module Mastercard
  module Masterpass
    class MasterpassService < Mastercard::Common::Connector
        
        include REXML
        
        attr_accessor :origin_url
        
        OAUTH_TOKEN = 'oauth_token'
        OAUTH_VERIFIER = 'oauth_verifier'
        OAUTH_TOKEN_SECRET = 'oauth_token_secret'
        OAUTH_CALLBACK = 'oauth_callback'
        OAUTH_CALLBACK_CONFIRMED = 'oauth_callback_confirmed'
        OAUTH_EXPIRES_IN = 'oauth_expires_in'
        REALM = "realm"
        REALM_TYPE = "eWallet"
        ORIGIN_URL = "originUrl"
        
        REQUEST_AUTH_URL = "xoauth_request_auth_url"
        URL_FORMAT = "?oauth_token%s&acceptable_cards=%s&checkout_identifier=%s&version=%s"
        
        SUPPRESS_SHIPPING_URL_PARAMETER = "&suppress_shipping_address="
        AUTH_LEVEL_BASIC_URL_PARAMETER = "&auth_level=basic"
        ACCEPT_REWARD_PROGRAM = "accept_reward_program"
        SHIPPING_LOCATION_PROFILE = "shipping_location_profile"
        
        DEFAULT_VERSION = "v1"
        XML_VERSION_REGEX = "v[0-9]+"
        
        
        
        def initialize(consumer_key, private_key, origin_url, environment)
            super(consumer_key, private_key)
            @environment = environment
            @origin_url = origin_url
        end
        
        def oauth_parameters_factory
            params = super
            params.add_parameter REALM, REALM_TYPE
            params
        end 
        
        def get_request_token(request_url, callback_url)
            params = self.oauth_parameters_factory
            params.add_parameter OAUTH_CALLBACK, callback_url
            
            response = parse_request_token_response(do_request(request_url, POST, EMPTY_STRING, params))
        end
        
        def get_access_token(access_url, request_token, oauth_verifier)
            params = self.oauth_parameters_factory
            params.add_parameter OAUTH_TOKEN, request_token
            params.add_parameter OAUTH_VERIFIER, oauth_verifier
            response = parse_access_token_response(do_request(access_url, POST, EMPTY_STRING, params))
        end
        
        def get_pairing_token(request_url, callback_url)
            response = get_request_token(request_url, callback_url)
        end
        
        def get_long_access_token(access_url, request_token, oauth_verifier)
          response = get_access_token(access_url, request_token, oauth_verifier)
        end
        
        def post_shopping_cart_data(shopping_cart_url, shopping_cart_xml)
            response = post_xml_data(shopping_cart_url, shopping_cart_xml)
        end
        
        def post_merchant_init_data(merchant_init_url, merchant_init_xml)
            response = post_xml_data(merchant_init_url, merchant_init_xml)
        end
        
        def get_precheckout_data(precheckout_url, precheckout_xml, access_token)
            params = self.oauth_parameters_factory
            params.add_parameter OAUTH_TOKEN, access_token
            
            response = post_xml_data(precheckout_url, precheckout_xml, params)
        end
        
        def get_payment_shipping_resource(checkout_resource_url, access_token)
          if (checkout_resource_url == nil || access_token ==nil) 
            raise "cannot process payment shipping resource request without url and token"
          end
          
          params = self.oauth_parameters_factory
          params.add_parameter OAUTH_TOKEN, access_token
          response = do_request(checkout_resource_url, GET, nil, params)
        end
        
        def post_checkout_transaction(postback_url, merchant_transactions_xml)
          response = post_xml_data(postback_url, merchant_transactions_xml.to_s)
        end
        
        def get_express_checkout_data(express_checkout_url, express_checkout_request_xml, access_token)
          params = self.oauth_parameters_factory
          params.add_parameter OAUTH_TOKEN, access_token
          response = do_request(express_checkout_url, POST, express_checkout_request_xml, params)
          response
        end
        
        private
        
        def parse_request_token_response(response)
             vars = CGI::parse(response)
             response_token = Mastercard::Masterpass::RequestTokenResponse.new
             vars.each do |v|
                method = v[0]
                value = vars[method][0]
                response_token.class.send(:define_method, method.to_sym) do
                   value
                end
             end
             response_token 
        end
        
        def parse_access_token_response(response)
             vars = CGI::parse(response)
             response_token = Mastercard::Masterpass::AccessTokenResponse.new
             vars.each do |v|
                method = v[0]
                value = vars[method][0]
                response_token.class.send(:define_method, method.to_sym) do
                   value
                end
             end
             response_token 
        end
        
        def post_xml_data(url, xml_data, params=nil)
            if (xml_data == nil)
              raise "XML Data cannot be nil"
            end
            params = oauth_parameters_factory if !params
         		response = do_request(url,POST,xml_data,params)
         		return response
        end
        
        
    end
  end
end