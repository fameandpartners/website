module Spree
  class Gateway
    class AfterpayPayment < Gateway
      preference :username, :string, default: ''
      preference :password, :string, default: ''

      attr_accessible :preferred_username,
                      :preferred_password

      # Spree Gateway methods

      def auto_capture?
        true
      end

      def supports?(source)
        true
      end

      def provider_class
        ::Afterpay::SDK::Merchant
      end

      def provider
        ::Afterpay::SDK.configure(
          mode: (preferred_server.presence || :sandbox).to_sym,
          username: preferred_username,
          password: preferred_password
        )
        provider_class.new
      end

      def currency
        'AUD'
      end

      def method_type
        'afterpay'
      end

      # Payment Actions

      def purchase(amount, transaction_details, options = {})
        # ActiveMerchant::Billing::Response.new(true, 'success', {}, {})
        # TODO: here is where the magic happens

        ActiveMerchant::Billing::Response.new(true, 'Bogus Gateway: Forced success', {}, test: true, authorization: '12345', avs_result: { code: 'A' })
      end

      def refund(payment, amount)
        # TODO
      end
    end
  end
end
