module Spree
  class Gateway::NabTransactGateway < Gateway
    preference :login, :string
    preference :password, :string
    preference :currency, :string, :default => 'AUD'

    attr_accessible :preferred_login, :preferred_password, :preferred_currency

    def purchase(money, creditcard, gateway_options)
      provider.purchase(money, creditcard, gateway_options)
    end

    def provider_class
      ActiveMerchant::Billing::NabTransactGateway
    end
  end
end
