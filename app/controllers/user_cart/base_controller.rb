class UserCart::BaseController < ApplicationController
  #rescue_from Errors::Cart::
  
  private

  def check_authorization
    access_token = params[:token] || session[:access_token]

    if params[:id].present?
      order = Spree::Order.find_by_number(params[:id]) || current_order
    else
      order = current_order
    end

    if order
      authorize! :edit, order, access_token
    else
      authorize! :create, Spree::Order
    end
  end

  def associate_user
    @order ||= current_order
    if try_spree_current_user && @order
      if @order.user.blank? || @order.email.blank?
        @order.associate_user!(try_spree_current_user)
      end
    end

    # This will trigger any "first order" promotions to be triggered
    # Assuming of course that this session variable was set correctly in
    # the authentication provider's registrations controller
    if session[:spree_user_signup]
      fire_event('spree.user.signup', :user => try_spree_current_user, :order => current_order(true))
    end

    session[:guest_token] = nil
    session[:spree_user_signup] = nil
  end
end
