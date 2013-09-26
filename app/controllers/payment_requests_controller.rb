class PaymentRequestsController < ApplicationController
  respond_to :js

  def new
  end

  def create
    @payment_request = PaymentRequest.new(params[:payment_request]) do |object|
      object.order = current_order
    end

    unless spree_user_signed_in?
      @user = Spree::User.new(params[:user])

      if @user.save
        sign_in(:spree_user, @user)
        current_order.user = @user
        current_order.save
      else
        @payment_request.valid?
        return
      end
    end

    @payment_request.save
  end
end
