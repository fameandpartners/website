class ReturnsController < ApplicationController
  respond_to :json
  layout 'returns/application'

  def main
    user = spree_current_user
    if user.present?
      render 'layouts/returns/main'
    else
      redirect_to spree_login_path
    end
  end

  def guest
    render 'layouts/returns/guest'
  end

  def lookup
  	id = params[:id]
  	email = params[:email]
  	@order = Spree::Order.find_by_number(id)
  	if @order.present? && @order.email == email
  	  respond_with(@order)
  	else
  	  respond_with({ status: :not_found, :message => "Sorry the order number and/or email you entered are incorrect. Please check them and enter again." })
  	end
  end
end
