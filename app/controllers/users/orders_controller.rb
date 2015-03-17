class Users::OrdersController < Users::BaseController
  def index
    @title = 'My Orders'

    user = try_spree_current_user
    @orders = user.orders.complete

    respond_with(@orders) do |format|
      format.html {}
      format.js   {}
    end
  end

  def show
    user = try_spree_current_user
    @order = user.orders.where(number: params[:id]).first
    @user_cart = ::UserCart::UserCartResource.new(order: @order).read

    @title = "Order ##{ @order.number }"

    respond_with(@order) do |format|
      format.html { render 'spree/orders/show' }
      format.js
    end
  end
end
