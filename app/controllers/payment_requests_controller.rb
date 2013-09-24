class PaymentRequestsController < ApplicationController
  respond_to :js

  def new
    @payment_request = PaymentRequest.new
  end

  def create
    user_attributes = params[:payment_request].delete(:user)

    @payment_request = PaymentRequest.new(params[:payment_request]) do |object|
      object.order = current_order
    end

    if params[:variant_id] && current_order(true).line_items.find_by_variant_id(params[:variant_id]).blank?
      populator = Spree::OrderPopulator.new(current_order(true), current_currency)

      if populator.populate(variants: { params[:variant_id] => 1 })
        product = Spree::Variant.where(id: params[:variant_id]).first.try(:product)

        Activity.log_product_added_to_cart(product, temporary_user_key, try_spree_current_user, current_order) rescue nil
      else
        @payment_request.valid?
        return
      end
    end

    unless spree_user_signed_in?
      @user = Spree::User.new(user_attributes)

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
