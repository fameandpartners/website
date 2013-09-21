class PaymentRequestsController < ApplicationController
  before_filter :authenticate_spree_user!

  respond_to :js

  def new
    @payment_request = PaymentRequest.new
  end

  def create
    @payment_request = PaymentRequest.create(params[:payment_request]) do |object|
      object.order = current_order
    end
  end
end
