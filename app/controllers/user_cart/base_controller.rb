class UserCart::BaseController < ApplicationController
  #rescue_from Errors::Cart::
  
  private

    def user_cart_resource
      @cart_resource ||= UserCart::UserCartResource.new(
        order: current_order,
        site_version: current_site_version
      )
    end

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
end
