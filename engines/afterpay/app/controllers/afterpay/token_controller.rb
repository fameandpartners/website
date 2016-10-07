module Afterpay
  class TokenController < ActionController::Base
    def new
      payment_presenter = Presenters::Payment.new(
        spree_order:          spree_order,
        spree_payment_method: spree_payment_method,
        rails_request:        request
      )

      render json: { token: payment_presenter.get_token }
    end

    private

    def spree_order
      @spree_order ||= Spree::Order.where(number: params[:order_number]).first
    end

    def spree_payment_method
      @spree_payment_method ||= Spree::PaymentMethod.where(id: params[:payment_method_id]).first
    end
  end
end
