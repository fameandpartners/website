module Afterpay
  class PaymentsController < ActionController::Base
    # This method is called with pre approval (more info at http://docs.afterpay.com.au/merchant-api-v1.html#direct-payment-flow)
    # => We now have to call `/v1/payments/capture`
    # => Sample parameters {"status"=>"SUCCESS", "orderToken"=>"664ku47hgk8nv5cplhd1k52noce2pjs9asjkq5cnr4hnfd18qeko", "order_number"=>"R884754500"}
    def new
      binding.pry


      # order.payments.create!({
      #                          :source => Spree::PaypalExpressCheckout.create({
      #                                                                           :token => params[:token],
      #                                                                           :payer_id => params[:PayerID]
      #                                                                         }, :without_protection => true),
      #                          :amount => order.total,
      #                          :payment_method => payment_method
      #                        }, :without_protection => true)
      # order.next

      # if order.complete?
      #   flash.notice = t(:order_processed_successfully)
      #   flash[:commerce_tracking] = "nothing special"
      #   session[:order_id] = nil
      #   redirect_to order_path(order, :token => order.token)
      # else
      #   redirect_to checkout_state_path(order.state)
      # end

      # If fails, redirect to checkout path
      payment_failed = true
      if payment_failed
        redirect_to spree.checkout_state_path(state: :payment), notice: 'Payment Failed'
      else
        redirect_to spree.checkout_state_path(state: :success)
      end
    end

    private

    def provider
      payment_method = Spree::PaymentMethod.where(type: 'Spree::Gateway::AfterpayPayment').available.first
      payment_method.provider
    end

    def current_order
      Spree::Order.where(number: params[:order_number]).first
    end
  end
end
