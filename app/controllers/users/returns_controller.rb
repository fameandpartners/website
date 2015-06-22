class Users::ReturnsController < Users::BaseController
  attr_reader :order_return
  helper_method :order_return

  def new
    user = try_spree_current_user
    order = user.orders.where(number: params[:order_number]).first
    @order_return = OrderReturnRequest.new(:order => order, :order_id => order.id)
    @order_return.build_items

    @title = "Order ##{ @order_return.number }"
  end

  def create
    user = try_spree_current_user
    @order_return = OrderReturnRequest.new(params[:order_return_request])
    if @order_return.save
      OrderReturnRequestMailer.email(@order_return, user).deliver
      render 'success'
    else
      @title = "Order ##{ @order_return.number }"
      render 'new'
    end

  end

end
