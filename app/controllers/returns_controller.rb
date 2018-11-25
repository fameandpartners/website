class ReturnsController < ApplicationController
  respond_to :json

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
