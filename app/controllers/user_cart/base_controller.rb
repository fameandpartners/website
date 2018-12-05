class UserCart::BaseController < Api::ApiBaseController

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
end
