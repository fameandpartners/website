class Users::OrdersController < Users::BaseController
  attr_reader :order
  helper_method :order

  def index
    @title = 'My Orders'

    user = try_spree_current_user
    @orders = user.orders.complete.map do |order|
      Orders::OrderPresenter.new(order)
    end

    respond_with(@orders) do |format|
      format.html {}
      format.js   {}
    end
  end

  def show
    user = try_spree_current_user
    order = user.orders.find_by_number!(params[:id])
    @order = Orders::OrderPresenter.new(order)

    @title = "Order ##{ @order.number }"

    respond_with(@order) do |format|
      format.html { render 'spree/orders/show' }
      format.js
    end
  end

end
