require 'mastercard_masterpass_api'
module Spree
  class Gateway::Masterpass < Gateway
    preference :consumer_key, :string
    preference :checkout_identifier, :string
    preference :callback_domain, :string, default: 'http://www.fameandpartners.com'
    preference :accepted_cards, :string, default: 'master,amex,diners,discover,maestro,visa'
    preference :shipping_suppression, :boolean, default: true
    preference :server, :string, default: 'sandbox'

    attr_accessible :preferred_consumer_key, :preferred_checkout_identifier, :preferred_accepted_cards,
                    :preferred_shipping_suppression, :preferred_server, :preferred_callback_domain

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

    def server_mode
      preferred_server.present? && preferred_server == 'live' ? Mastercard::Common::PRODUCTION : Mastercard::Common::SANDBOX
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
      # true
      false
    end

    def purchase(amount, masterpass_checkout, gateway_options={})
      approval_code = "sample"
      if (!approval_code)
        approval_code = "UNAVBL"
      end
      merchant_transactions = AllServicesMappingRegistry::MerchantTransactions.new
      merchant_transaction = AllServicesMappingRegistry::MerchantTransaction.new(
          masterpass_checkout.transaction_id,
          preferred_consumer_key,
          gateway_options[:currency],
          amount,
          Time.now,
          "Success",
          approval_code,
          masterpass_checkout.precheckout_transaction_id)
      merchant_transactions << merchant_transaction
      xml = merchant_transactions.to_xml
      # we need to pluralize the child MerchantTransaction node name to adhere to the XML schema
      REXML::XPath.first(xml, "//MerchantTransaction").name = "MerchantTransactions"
      post_transaction_sent_xml = xml.to_s
      response_xml = ""
      service = Mastercard::Masterpass::MasterpassService.new(
          preferred_consumer_key,
          OpenSSL::PKCS12.new(File.open(keystore[:path]), keystore[:password]).key,
          preferred_callback_domain,
          server_mode)
      response_xml = Document.new(service.post_checkout_transaction(postback_url, xml), {:compress_whitespace => :all})

      # and change the child MerchantTransaction node name back to singular for proper xml mapping if we want to get a Ruby object back from the xml
      REXML::XPath.first(response_xml, "//MerchantTransactions/*[not(root)]").name = "MerchantTransaction"
      # AllServicesMappingRegistry::MerchantInitializationResponse.from_xml(response_xml.to_s)

      transaction_response = AllServicesMappingRegistry::MerchantTransactions.from_xml(response_xml.to_s)
      if transaction_response.first.transactionStatus == "Success"
        # We need to store the transaction id for the future.
        # This is mainly so we can use it later on to refund the payment if the user wishes.
        masterpass_checkout.update_column(:transaction_id, transaction_response.first.transactionId)
        # masterpass_checkout.update_column(:order_id, gateway_options[:order_id])
        # This is rather hackish, required for payment/processing handle_response code.
        Class.new do
          def success?; true; end
          def authorization; nil; end
        end.new
      else
        class << transaction_response
          def to_s
            errors.map(&:long_message).join(" ")
          end
        end
        transaction_response
      end
    end

    def refund(payment, amount)

    end
  end
end
