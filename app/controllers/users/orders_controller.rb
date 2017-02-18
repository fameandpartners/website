class Users::OrdersController < Users::BaseController
  attr_reader :order
  helper_method :order

  include Marketing::Gtm::Controller::Order

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
    order = user.orders.find_by_number(params[:id])
    @order = Orders::OrderPresenter.new(order)

    append_gtm_order(spree_order: order, action_dispatch_request: request)

    @title = "Order ##{ @order.number }"

    respond_with(@order) do |format|
      format.html { render 'spree/orders/show' }
      format.js
    end
  end

end
