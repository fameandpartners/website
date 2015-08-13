require 'mastercard_masterpass_api'
module Spree
  class Gateway::MasterPass < Gateway
    preference :consummer_key, :string
    preference :checkeout_identifier, :string
    preference :keystore_path, :string
    preference :keystore_password, :string

    preference :server, :string, default: 'sandbox'

    def supports?(source)
      true
    end

    def provider_class
      Mastercard::Masterpass::MasterpassService
    end

    def provider
      @provider ||= Mastercard::Masterpass::MasterpassService.new(consumer_key, generate_private_key, Spree::Config.site_url, server == "sandbox" ? Mastercard::Common::SANDBOX : Mastercard::Common::PRODUCTION)
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