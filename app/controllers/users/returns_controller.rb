class Users::ReturnsController < Users::BaseController
  attr_reader :order, :order_return
  helper_method :order, :order_return

  def new
    user = try_spree_current_user
    order = user.orders.where(number: params[:order_id]).first
    @order_return = Return.new
    @order = Orders::OrderPresenter.new(order)

    @title = "Order ##{ @order.number }"
  end

  def create
    @return = Returns.new(params[:id])
  end

end
