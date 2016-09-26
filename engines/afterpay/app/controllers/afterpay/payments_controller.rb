module Afterpay
  class PaymentsController < ActionController::Base
    AFTERPAY_APPROVED_PAYMENT = 'APPROVED'.freeze

    # This method is called with pre approval (more info at http://docs.afterpay.com.au/merchant-api-v1.html#direct-payment-flow)
    # => We now have to call `/v1/payments/capture`
    # => Sample parameters {"status"=>"SUCCESS", "orderToken"=>"664ku47hgk8nv5cplhd1k52noce2pjs9asjkq5cnr4hnfd18qeko", "order_number"=>"R884754500"}
    # Note: Afterpay payment ID is used to refund, so it's necessary saving it on the payment transaction as a response_code
    # TODO: handle failure case and notifications
    def new
      payment_status, payment_id = begin
        payment_details = provider.direct_capture_payment(token: params[:orderToken])
        payment_details.values_at('status', 'id')
      rescue Afterpay::SDK::Core::Exceptions::ClientError => e
        Raven.capture_exception(e)
        nil
      end

      if payment_status == AFTERPAY_APPROVED_PAYMENT
        afterpay_source = Spree::CreditCard.create(
          number:                     '1234 1234 1234 1234',
          verification_value:         '123',
          cc_type:                    'master',
          gateway_payment_profile_id: payment_id
        )

        current_order.payments.create!({
                                         source:         afterpay_source,
                                         amount:         current_order.total,
                                         payment_method: payment_method
                                       },
                                       without_protection: true)

        current_order.next
      end

      if current_order.complete?
        GuestCheckoutAssociation.call(spree_order: current_order)
        flash.notice              = t(:order_processed_successfully)
        flash[:commerce_tracking] = 'nothing special'
        session[:order_id]        = nil
        redirect_to spree.order_path(current_order, token: current_order.token)
      else
        redirect_to spree.checkout_state_path(current_order.state)
      end
    end

    private

    def payment_method
      @payment_method ||= Spree::PaymentMethod.where(type: 'Spree::Gateway::AfterpayPayment').available.first
    end

    def provider
      @provider ||= payment_method.provider
    end

    def current_order
      @current_order ||= Spree::Order.where(number: params[:order_number]).first
    end
  end
end
