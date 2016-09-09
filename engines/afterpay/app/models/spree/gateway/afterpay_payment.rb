module Spree
  class Gateway
    class AfterpayPayment < Gateway
      preference :merchant_id, :string, default: ''
      preference :merchant_key, :string, default: ''
      preference :server, :string, default: 'sandbox'

      attr_accessible :preferred_merchant_id,
                      :preferred_merchant_key,
                      :preferred_server

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
        Spree::Gateway::Bogus
      end

      def currency
        'AUD'
      end

      # Payment Actions

      def purchase(amount, transaction_details, options = {})
        # ActiveMerchant::Billing::Response.new(true, 'success', {}, {})
        # TODO: here is where the magic happens

        ActiveMerchant::Billing::Response.new(true, 'Bogus Gateway: Forced success', {}, :test => true, :authorization => '12345', :avs_result => { :code => 'A' })
      end

      def refund(payment, amount)
        # TODO
      end
    end
  end
end
