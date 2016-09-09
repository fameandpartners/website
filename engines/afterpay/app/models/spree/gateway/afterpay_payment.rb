module Spree
  class Gateway
    class AfterpayPayment < Gateway
      preference :merchant_id, :string, default: ''
      preference :merchant_key, :string, default: ''
      preference :server, :string, default: 'sandbox'

      # Spree Gateway methods

      def auto_capture?
        true
      end

      def supports?(source)
        true
      end

      def provider_class
        # TODO: Actual API wrapper here
        # More information: https://github.com/spree/spree/blob/1-3-stable/core/app/models/spree/gateway.rb#L27
      end

      def payment_source_class
        Spree::CreditCard
      end

      # Payment Actions

      def purchase(amount, transaction_details, options = {})
        # ActiveMerchant::Billing::Response.new(true, 'success', {}, {})
        # TODO: here is where the magic happens
      end

      def refund(payment, amount)
        # TODO
      end
    end
  end
end
