module Spree
  class Gateway
    class QuadpayPayment < PaymentMethod
      # preference :username, :string, default: ''
      # preference :password, :string, default: ''
      #
      # attr_accessible :preferred_username,
      #                 :preferred_password

      # Spree Gateway methods

      def auto_capture?
        true
      end

      def supports?(source)
        true
      end

      # def provider_class
      #   ::Afterpay::SDK::Merchant
      # end
      #
      # def provider
      #   ::Afterpay::SDK.configure(
      #     mode: (preferred_server.presence || :sandbox).to_sym,
      #     username: preferred_username,
      #     password: preferred_password
      #   )
      #   provider_class.new
      # end

      def currency
        'USD'
      end

      def method_type
        'quadpay'
      end

      # Payment Actions

      # def purchase(amount, payment_source, options = {})
      #   #ActiveMerchant::Billing::Response.new(true, 'AfterPay Gateway: Success', {}, authorization: payment_source.gateway_payment_profile_id)
      # end

      # def refund(payment, amount)
      #   # TODO
      # end
    end
  end
end
